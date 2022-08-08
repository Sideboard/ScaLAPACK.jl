include("common.jl")

@testset "PBLAS" begin

function test_pdgemm!_2X1_2x2()
    ictxt = sl_init(2, 1)
    mypnum >= 2 && return

    if mypnum == 0
        A = [1.0 2.0 ; 3.0 4.0]
        B = [0.0;;]
        C = zeros(2, 2)
    else
        A = [0.0;;]
        B = [5.0 6.0 ; 7.0 8.0]
        C = [0.0;;]
    end
    descA = descinit(2, 2, 2, 2, 0, 0, ictxt, 2)
    descB = descinit(2, 2, 2, 2, 1, 0, ictxt, 2)
    descC = descinit(2, 2, 2, 2, 0, 0, ictxt, 2)

    # pdgemm(transa, transb, m, n, k, alpha, A, ia, ja, desca,
    #     B, ib, jb, descb, beta, C, ic, jc, descc)
    pdgemm!('N', 'N', 2, 2, 2, 1.0, A, 1, 1, descA, B, 1, 1, descB, 1.0, C, 1, 1, descC)
    if mypnum == 0
        @test C == [19.0 22.0 ; 43.0 50.0]
    else
        @test C == [0.0;;]
    end

    blacs_gridexit(ictxt)
end

function test_pdgemm!_2X1_3x4_4x3_3x3()
    ictxt = sl_init(2, 1)
    mypnum >= 2 && return

    if mypnum == 0
        A = [1.0 4.0 7.0 10.0 ; 2.0 5.0 8.0 11.0]
        B = [13.0 17.0 21.0 ; 14.0 18.0 22.0]
        C = [25.0 28.0 31.0 ; 26.0 29.0 32.0]
        descA = descinit(3, 4, 2, 4, 0, 0, ictxt, 2)
        descB = descinit(4, 3, 2, 3, 0, 0, ictxt, 2)
        descC = descinit(3, 3, 2, 3, 0, 0, ictxt, 2)
    else
        A = [3.0 6.0 9.0 12.0]
        B = [15.0 19.0 23.0 ; 16.0 20.0 24.0]
        C = [27.0 30.0 33.0]
        descA = descinit(3, 4, 2, 4, 0, 0, ictxt, 1)
        descB = descinit(4, 3, 2, 3, 0, 0, ictxt, 2)
        descC = descinit(3, 3, 2, 3, 0, 0, ictxt, 1)
    end

    # pdgemm(transa, transb, m, n, k, alpha, A, ia, ja, desca,
    #     B, ib, jb, descb, beta, C, ic, jc, descc)
    pdgemm!('N', 'N', 3, 3, 4, 3.0, A, 1, 1, descA, B, 1, 1, descB, 2.0, C, 1, 1, descC)
    if mypnum == 0
        @test C == [1052.0 1322.0 1592.0 ; 1228.0 1546.0 1864.0]
    else
        @test C == [1404.0 1770.0 2136.0]
    end

    blacs_gridexit(ictxt)
end

function test_pdtrmm!_2X1_2x2()
    ictxt = sl_init(2, 1)
    mypnum >= 2 && return

    if mypnum == 0
        A = [0.0;;]
        B = [4.0 5.0 ; 6.0 7.0]
    else
        A = [1.0 2.0 ; -100.0 3.0]
        B = [0.0;;]
    end
    descA = descinit(2, 2, 2, 2, 1, 0, ictxt, 2)
    descB = descinit(2, 2, 2, 2, 0, 0, ictxt, 2)

    # pdtrmm!(side, uplo, transa, diag, m, n, alpha, A, ia, ja, desca, B, ib, jb, descb)
    pdtrmm!('L', 'U', 'N', 'N', 2, 2, 1.0, A, 1, 1, descA, B, 1, 1, descB)
    if mypnum == 0
        @test B == [16.0 19.0 ; 18.0 21.0]
    else
        @test B == [0.0;;]
    end

    blacs_gridexit(ictxt)
end

function test_pdtrmm!_2X1_3x4R_4x3()
    ictxt = sl_init(2, 1)
    mypnum >= 2 && return

    if mypnum == 0
        A = [1.0 2.0 4.0 7.0 ; -100.0 3.0 5.0 8.0]
        B = [12.0 16.0 20.0 ; 13.0 17.0 21.0]
        descA = descinit(3, 4, 2, 3, 0, 0, ictxt, 2)
        descB = descinit(4, 3, 2, 3, 1, 0, ictxt, 2)
    else
        A = [-100.0 -100.0 6.0 9.0]
        B = [10.0 14.0 18.0 ; 11.0 15.0 19.0]
        descA = descinit(3, 4, 2, 4, 0, 0, ictxt, 1)
        descB = descinit(4, 3, 2, 3, 1, 0, ictxt, 2)
    end

    # pdtrmm!(side, uplo, transa, diag, m, n, alpha, A, ia, ja, desca, B, ib, jb, descb)
    pdtrmm!('R', 'U', 'N', 'N', 4, 3, 2.0, A, 1, 1, descA, B, 1, 1, descB)
    if mypnum == 0
        @test B == [24.0 144.0 496.0; 26.0 154.0 526.0]
    else
        @test B == [20.0 124.0 436.0; 22.0 134.0 466.0]
    end

    blacs_gridexit(ictxt)
end

@testset "pdgemm!" begin
    test_pdgemm!_2X1_2x2()
    test_pdgemm!_2X1_3x4_4x3_3x3()
end

@testset "pdtrmm!" begin
    test_pdtrmm!_2X1_2x2()
    test_pdtrmm!_2X1_3x4R_4x3()
end

blacs_exit(0)

end
