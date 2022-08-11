using Test, ScaLAPACK

function split_grid_full(nprocs)
    maxnpcol = floor(sqrt(nprocs))
    nprow = npcol = 0
    for i in maxnpcol:-1:1
        nprow = floor(nprocs / i)
        npcol = i

        nprow * npcol == nprocs && break
    end
    return nprow, npcol
end

mypnum, nprocs = blacs_pinfo()
mypnum != 0 && redirect_stdout(open("/dev/null", write=true))
nprocs < 2 && error("ScaLAPACK.jl tests expect at least two processes, detected: $nprocs")

grids = [(nprocs, 1), (1, nprocs)]
push!(grids, split_grid_full(nprocs))
unique!(grids)
