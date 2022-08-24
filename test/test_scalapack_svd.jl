A0 = [1.0 4.0 9.0 ; 6.0 2.0 5.0 ; 10.0 7.0 3.0 ; 12.0 11.0 8.0]

Audev0 = [-16.763054614240207 16.309833725595848 0.3357735363111517;
0.337779741733719 -8.316138258438984 4.4249889681381855;
0.562966236222865  0.547890371466363 3.7750021114960064;
0.675559483467438 0.2674849393680686 0.4006490645217627]
d0 = [-16.763054614240207, -8.316138258438984, 3.7750021114960064]
e0 = [16.309833725595848, 4.4249889681381855, 0.0]
tauQ0 = [1.0596549986271893, 1.458010693254406, 1.7233658736680528]
tauP0 = [1.7973588155174267, 0.0, 0.0]

function test_pdgebrd!()
    ictxt = sl_init(2, 1)
    mypnum >= 2 && return

    if mypnum == 0
        A = A0[1:2,:]
    else
        A = A0[3:4,:]
    end
    descA = descinit(4, 3, 2, 2, 0, 0, ictxt, 2)

    # dgebrd(m, n, A, ia, ja, desca, d, e, tauq, taup, work, lwork, info)
    d = zeros(3)
    e = zeros(3)
    tauQ = zeros(3)
    tauP = zeros(3)
    work = zeros(1)
    info = Ref{Cint}(-1)
    pdgebrd!(4, 3, A, 1, 1, descA, d, e, tauQ, tauP, work, -1, info)
    @test info[] == 0
    lwork = Cint(work[1])
    work = zeros(lwork)
    pdgebrd!(4, 3, A, 1, 1, descA, d, e, tauQ, tauP, work, lwork, info)
    @test info[] == 0

    if mypnum == 0
        @test A ≈ Audev0[1:2,:]
        @test e ≈ e0
        @test tauP ≈ tauP0
    else
        @test A ≈ Audev0[3:4,:]
        @test e ≈ zeros(3)
        @test tauP ≈ zeros(3)
    end
    @test d ≈ d0
    @test tauQ ≈ tauQ0

    blacs_gridexit(ictxt)
end

@testset "pdgebrd!" begin
    test_pdgebrd!()
end
