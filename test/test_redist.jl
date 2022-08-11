include("common.jl")

@testset "REDIST" begin

function test_copy()
@testset "[4x3(4x3)] {2X1}->{2X1} [4x3(4x3)<1,0>]" begin
    ictxt = sl_init(2, 1)
    mypnum >= 2 && return

    if mypnum == 0
        A = [1.0 5.0 9.0 ; 2.0 6.0 10.0 ; 3.0 7.0 11.0 ; 4.0 8.0 12.0]
        B = zeros(4, 3)
    else
        A = [0.0;;]
        B = [0.0;;]
    end
    descA = descinit(4, 3, 4, 3, 0, 0, ictxt, 4)
    descB = descinit(4, 3, 4, 3, 0, 0, ictxt, 4)

    # pdgemr2d(m, n, A, ia, ja, desc_A, B, ib, jb, desc_B, gcontext)
    pdgemr2d!(4, 3, A, 1, 1, descA, B, 1, 1, descB, ictxt)
    if mypnum == 0
        @test B == [1.0 5.0 9.0 ; 2.0 6.0 10.0 ; 3.0 7.0 11.0 ; 4.0 8.0 12.0]
    else
        @test B == [0.0;;]
    end

    blacs_gridexit(ictxt)
end
end

function test_change_blocksize()
@testset "[4x3(4x3)] {2X1}->{2X1} [3x3(2x3)<1,0>]" begin
    ictxt = sl_init(2, 1)
    mypnum >= 2 && return

    if mypnum == 0
        A = [1.0 5.0 9.0 ; 2.0 6.0 10.0 ; 3.0 7.0 11.0 ; 4.0 8.0 12.0]
    else
        A = [0.0;;]
    end
    B = zeros(2, 3)
    descA = descinit(4, 3, 4, 3, 0, 0, ictxt, 4)
    descB = descinit(4, 3, 2, 3, 1, 0, ictxt, 2)

    # pdgemr2d(m, n, A, ia, ja, desc_A, B, ib, jb, desc_B, gcontext)
    pdgemr2d!(4, 3, A, 1, 1, descA, B, 1, 1, descB, ictxt)
    if mypnum == 0
        @test B == [3.0 7.0 11.0 ; 4.0 8.0 12.0]
    else
        @test B == [1.0 5.0 9.0 ; 2.0 6.0 10.0]
    end

    blacs_gridexit(ictxt)
end
end

function test_change_context()
@testset "[3x4(3x2)] {1X2}->{1X1} [3x4(3x4)]" begin
    ictxt12 = sl_init(1, 2)
    ictxt11 = sl_init(1, 1)
    mypnum >= 2 && return

    descA = descinit(3, 4, 3, 2, 0, 1, ictxt12, 3)
    if mypnum == 0
        A = [7.0 10.0 ; 8.0 11.0 ; 9.0 12.0]
        B = zeros(3, 4)
        descB = descinit(3, 4, 3, 2, 0, 0, ictxt11, 3)
    else
        A = [1.0 4.0 ; 2.0 5.0 ; 3.0 6.0]
        B = [0.0;;]
        descB = deepcopy(descA)
        descB[2] = -1
    end

    # pdgemr2d(m, n, A, ia, ja, desc_A, B, ib, jb, desc_B, gcontext)
    pdgemr2d!(3, 4, A, 1, 1, descA, B, 1, 1, descB, ictxt12)
    if mypnum == 0
        @test B == [1.0 4.0 7.0 10.0 ; 2.0 5.0 8.0 11.0 ; 3.0 6.0 9.0 12.0]
    else
        @test B == [0.0;;]
    end

    blacs_gridexit(ictxt12)
    ictxt11 >= 0 && blacs_gridexit(ictxt11)
end
end

@testset "pdgemr2d!" begin
    test_copy()
    test_change_blocksize()
    test_change_context()
end

blacs_exit(0)

end
