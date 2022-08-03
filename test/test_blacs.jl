using Test, ScaLAPACK

mypnum, nprocs = blacs_pinfo()
mypnum != 0 && redirect_stdout(devnull)
nprocs < 2 && error("ScaLAPACK.jl tests expect at least two processes, detected: $nprocs")

function test_grid(nprocs, nprow, npcol)
    contxt = blacs_get(0, 0)
    @test 0 <= contxt
    blacs_gridinit(contxt, 'C', nprow, npcol)
    nprow, npcol, myrow, mycol = blacs_gridinfo(contxt)
    @test 0 <= myrow < nprow
    @test 0 <= mycol < npcol
    @test nprow * npcol <= nprocs
    blacs_gridexit(contxt)
end

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

@testset verbose = true "BLACS pinfo, get, gridinit, gridinfo, gridexit" begin
    @test 0 <= mypnum < nprocs
    nprocs > 0 || error("blacs_pinfo returned no processes: $nprocs")

    grids = [(nprocs, 1), (1, nprocs)]
    push!(grids, split_grid_full(nprocs))
    unique!(grids)

    @testset "BLACS grid ($nprocs, $nprow, $npcol)" for (nprow, npcol) in grids
        test_grid(nprocs, nprow, npcol)
    end
    blacs_exit(0)
end
