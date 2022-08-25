import Random
using ArgParse
using ScaLAPACK

include("common.jl")

function parse_commandline()
    s = ArgParseSettings()
    s.description = """
        Solve singular value decomposition (SVD):
            A(m,n) = U(m,m) S(m,n) V(n,n) with m ≫ n > 0 using {p,1} process grid

        We create the random numbers for A element-wise for reproducibility and locally to
        keep the memory peak small.
        
        V is the transpose of the column matrix (i.e. technically VT).
        """

    @add_arg_table s begin
        "--nrows", "-R"
            help = "Number of rows for matrix A"
            arg_type = Int
            default = 16
        "--ncols", "-C"
            help = "Number of columns for matrix A"
            arg_type = Int
            default = 4
        "--nblock", "-b"
            help = "Block size for matrix A"
            arg_type = Int
            default = 0

        "--afile", "-A"
            help = "File to write A into"
            arg_type = String
            default = ""
        "--ufile", "-U"
            help = "File to write U into"
            arg_type = String
            default = ""
        "--sfile", "-S"
            help = "File to write S into"
            arg_type = String
            default = ""
        "--vfile", "-V"
            help = "File to write V into"
            arg_type = String
            default = ""

        "--allout"
            help = "All processes print"
            action = :store_true
        "--order"
            help = "Whether matrices are row-major (R) or col-major (C) order"
            range_tester = (x -> x == 'R' || x == 'C')
            default = 'R'
    end

    return parse_args(s)
end

function solve_svd!(A::Array{Float64}, descA::Vector{Cint})
    ictxt = descA[2]
    mg = descA[3]
    ng = descA[4]
    mb = descA[5]

    nprow, npcol, myrow, mycol = blacs_gridinfo(ictxt)
    rg = min(mg, ng)
    ul = size(A, 1)
    vl = numroc(rg, mb, myrow, 0, nprow)

    s = zeros(rg)
    U = zeros(ul, rg)
    V = zeros(vl, ng)
    descU = descinit(mg, rg, mb, mb, 0, 0, ictxt, max(ul, 1))
    descV = descinit(rg, ng, mb, mb, 0, 0, ictxt, max(vl, 1))
    work = zeros(1)
    info = Ref{Cint}(-1)
    pdgesvd!('V', 'V', mg, ng, A, 1, 1, descA, s, U, 1, 1, descU, V, 1, 1, descV, work, -1,
        info)
    @assert info[] == 0
    lwork = Cint(work[1])
    work = zeros(lwork)
    pdgesvd!('V', 'V', mg, ng, A, 1, 1, descA, s, U, 1, 1, descU, V, 1, 1, descV, work,
        lwork, info)
    @assert info[] == 0

    return U, descU, s, V, descV
end

function main()
    args = parse_commandline()
    afile = strip(args["afile"])
    ufile = strip(args["ufile"])
    sfile = strip(args["sfile"])
    vfile = strip(args["vfile"])

    mypnum, nprocs = blacs_pinfo()
    args["allout"] && mypnum != 0 && redirect_stdout(open("/dev/null", "w"))

    ictxt = blacs_get(0, 0)
    blacs_gridinit(ictxt, args["order"], nprocs, 1)
    nprow, npcol, myrow, mycol = blacs_gridinfo(ictxt)

    mg = args["nrows"]
    if mg < 1
        mg = nprocs
    end
    ng = args["ncols"]

    nb = args["nblock"]
    if nb < 1
        nb = ceil(Integer, mg / nprow)
    end
    ml = numroc(mg, nb, myrow, 0, nprow)
    nl = numroc(ng, nb, mycol, 0, npcol)

    A = prand(mg, ng, nb, nb, ml, nl, nprow, npcol, myrow, mycol, seed=0)
    descA = descinit(mg, ng, nb, nb, 0, 0, ictxt, ml)
    length(afile) > 0 && pmatrix_to_file(A, afile, mypnum)

    U, descU, s, V, descV = solve_svd!(A, descA)
    length(ufile) > 0 && pmatrix_to_file(U, ufile, mypnum)
    length(sfile) > 0 && pmatrix_to_file(s, sfile, mypnum)
    length(vfile) > 0 && pmatrix_to_file(V, vfile, mypnum)

    blacs_gridexit(ictxt)
    blacs_exit(0)
end

main()
