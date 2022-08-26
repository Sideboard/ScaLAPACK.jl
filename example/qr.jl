import Random
using ArgParse
using ScaLAPACK

include("common.jl")

function parse_commandline()
    s = ArgParseSettings()
    s.description = """
        Solve least-squares problem via QR decomposition:
            A(m,n) X(n,k) = B(m,k) for X with m ≫ n > 0 using {p,1} process grid
        """

    @add_arg_table s begin
        "--nrows", "-R"
            help = "Number of rows for matrices A and B"
            arg_type = Int
            default = 16
        "--ncols", "-C"
            help = "Number of columns for matrix A"
            arg_type = Int
            default = 4
        "--nrhs", "-N"
            help = "Number of columns for matrix B"
            arg_type = Int
            default = 1

        "--nbrows", "-r"
            help = "Row block size for matrix A and B"
            arg_type = Int
            default = 0
        "--nbcols", "-c"
            help = "Col block size for matrix A"
            arg_type = Int
            default = 100
        "--nbrhs", "-n"
            help = "Col block size for matrix B"
            arg_type = Int
            default = 0

        "--afile", "-A"
            help = "File to write A into"
            arg_type = String
            default = ""
        "--bfile", "-B"
            help = "File to write B into"
            arg_type = String
            default = ""
        "--xfile", "-X"
            help = "File to write X into"
            arg_type = String
            default = ""

        "--allout"
            help = "All processes print"
            action = :store_true
        "--order"
            help = "Whether matrices are row-major (R) or col-major (C) order"
            range_tester = (x -> (x[1] == 'R') || (x[1] == 'C'))
            default = 'R'
    end

    return parse_args(s)
end

function solve_qr!(A::Array{Float64}, descA::Vector{Cint},
        B::Array{Float64}, descB::Vector{Cint})
    mg = descA[3]
    ng = descA[4]
    @assert mg == descB[3]
    kg = descB[4]

    tauA = zeros(min(mg, ng))
    work = zeros(1)
    info = Ref{Cint}(-1)

    pdgeqrf!(mg, ng, A, 1, 1, descA, tauA, work, -1, info)
    @assert info[] == 0
    lwork = Cint(work[1])
    work = zeros(lwork)
    pdgeqrf!(mg, ng, A, 1, 1, descA, tauA, work, lwork, info)
    @assert info[] == 0

    pdormqr!('L', 'T', mg, kg, ng, A, 1, 1, descA,
        tauA, B, 1, 1, descB, work, -1, info)
    @assert info[] == 0
    lwork = Cint(work[1])
    if lwork > length(work)
        work = zeros(lwork)
    end
    pdormqr!('L', 'T', mg, kg, ng, A, 1, 1, descA,
        tauA, B, 1, 1, descB, work, lwork, info)
    @assert info[] == 0

    # cheats trtrs that mb == nb without increasing memory for geqrf, ormqr; asserts q == 1
    nb = descA[6]
    descA[6] = descA[5]
    pdtrtrs!('U', 'N', 'N', ng, kg, A, 1, 1, descA, B, 1, 1, descB, info)
    @assert info[] == 0
    descA[6] = nb

    return B, descB
end

function main()
    args = parse_commandline()
    afile = strip(args["afile"])
    bfile = strip(args["bfile"])
    xfile = strip(args["xfile"])

    mypnum, nprocs = blacs_pinfo()
    !args["allout"] && mypnum != 0 && redirect_stdout(open("/dev/null", "w"))

    ictxt = blacs_get(0, 0)

    order = Char(args["order"][1])
    blacs_gridinit(ictxt, order, nprocs, 1)
    nprow, npcol, myrow, mycol = blacs_gridinfo(ictxt)
    nprow < 0 && error("BLACS grid broken, context: $ictxt")

    mg = args["nrows"]
    if mg < 1
        mg = nprocs
    end
    ng = args["ncols"]
    kg = args["nrhs"]

    mb = args["nbrows"]
    if mb < 1
        mb = ceil(Integer, mg / nprow)
    end
    nb = args["nbcols"]
    if nb < 1
        nb = ceil(Integer, ng / npcol)
    end
    kb = args["nbrhs"]
    if kb < 1
        kb = ceil(Integer, kg / npcol)
    end
    ml = numroc(mg, mb, myrow, 0, nprow)
    nl = numroc(ng, nb, mycol, 0, npcol)
    kl = numroc(kg, kb, mycol, 0, npcol)

    mg < ng && error("X will not fit into B: mg = $mg < $ng = ng")

    A = prand(mg, ng, mb, nb, ml, nl, nprow, npcol, myrow, mycol, seed=0)
    descA = descinit(mg, ng, mb, nb, 0, 0, ictxt, ml)
    length(afile) > 0 && pmatrix_to_file(A, afile, mypnum)

    B = prand(mg, kg, mb, kb, ml, kl, nprow, npcol, myrow, mycol, seed=1)
    descB = descinit(mg, kg, mb, kb, 0, 0, ictxt, ml)
    length(bfile) > 0 && pmatrix_to_file(B, bfile, mypnum)

    X, descX = solve_qr!(A, descA, B, descB)
    length(xfile) > 0 && pmatrix_to_file(X, xfile, mypnum)

    blacs_gridexit(ictxt)
    blacs_exit(0)
end

main()
