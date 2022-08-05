include("common.jl")

@testset "TOOLS" begin

@testset "numroc" begin
    # numroc(n, nb, iproc, isrcproc, nprocs)
    @test numroc(97, 9, 0, 1, 3) == 27
    @test numroc(97, 9, 1, 1, 3) == 36
    @test numroc(97, 9, 2, 1, 3) == 34
end

@testset "descinit" begin
    ictxt = blacs_get(0, 0)
    blacs_gridinit(ictxt, 'C', nprocs, 1)
    nprow, npcol, myrow, mycol = blacs_gridinfo(ictxt)

    # descinit(m, n, mb, nb, irsrc, icsrc, ictxt, lld)
    # -> [1, ictxt, m, n, mb, nb, irsrc, icsrc, lld]
    @test descinit(9, 7, 5, 3, 1, 0, ictxt, 8) == Cint[1, ictxt, 9, 7, 5, 3, 1, 0, 8]

    # silence ScaLAPACK error output
    redirect_stdout(devnull) do
        @test_throws ScaLAPACKError(-2) descinit(-1, 7, 5, 3, 1, 0, ictxt, 8)
        @test_throws ScaLAPACKError(-3) descinit(9, -1, 5, 3, 1, 0, ictxt, 8)
        @test_throws ScaLAPACKError(-4) descinit(9, 7, 0, 3, 1, 0, ictxt, 8)
        @test_throws ScaLAPACKError(-5) descinit(9, 7, 5, 0, 1, 0, ictxt, 8)
        @test_throws ScaLAPACKError(-6) descinit(9, 7, 5, 3, -1, 0, ictxt, 8)
        @test_throws ScaLAPACKError(-7) descinit(9, 7, 5, 3, 1, -1, ictxt, 8)
        @test_throws ScaLAPACKError(-9) descinit(9, 7, 5, 3, 1, 0, ictxt, 0)
    end

    blacs_gridexit(ictxt)
end

function test_sl_init(npr, npc)
    # sl_init(nprow, npcol)
    ictxt = sl_init(npr, npc)
    @test 0 <= ictxt
    nprow, npcol, myrow, mycol = blacs_gridinfo(ictxt)
    @test myrow < nprow == npr
    @test mycol < npcol == npc
    blacs_gridexit(ictxt)
end

@testset "sl_init($nprow, $npcol)" for (nprow, npcol) in grids
    test_sl_init(nprow, npcol)
end

blacs_exit(0)

end
