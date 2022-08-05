include("common.jl")

@testset "BLACS" begin

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

@testset "grid ($nprocs, $nprow, $npcol)" for (nprow, npcol) in grids
    test_grid(nprocs, nprow, npcol)
end

blacs_exit(0)

end
