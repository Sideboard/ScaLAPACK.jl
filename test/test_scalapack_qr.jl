A0 = [1.0 4.0 9.0 ; 6.0 2.0 5.0 ; 10.0 7.0 3.0 ; 12.0 11.0 8.0]
C0 = [13.0 15.0 ; 16.0 14.0 ; 18.0 17.0 ; 20.0 19.0]

HR0 = [-16.763054614240207 -13.004789700727283 -9.843074773486247;
         0.337779741733719   4.568965401473039  5.907876333135532;
         0.562966236222865   0.309535947265093  6.871017118006321;
         0.675559483467438   0.058673932460436  0.351892785948575]
tau0 = [1.0596549986271893, 1.8194138375705, 1.7796309148801537]
Q0 = [-0.0596549986271893  0.7056738243666165  0.6176345698354122;
      -0.3579299917631362 -0.5810515154276986  0.7145446939527557;
      -0.5965499862718937 -0.1659034487749330 -0.2753230023886708;
      -0.7158599835262723  0.3699724796624088 -0.1793060591387696]
QC0 = [-31.55749427378317 -29.648534317713114;
         4.29012298522222   6.659504633923381;
        10.92002928533298  11.180838098625735;
        -3.93349213031887  -4.754394835776723]
X0 = [ 1.8151831269701986  1.3147769003282306;
      -1.1160508270774423 -0.6465503233564057;
       1.5892886159045858  1.6272464333300831]

function test_pdgeqrf!()
    ictxt = sl_init(2, 1)
    mypnum >= 2 && return

    if mypnum == 0
        A = A0[1:2,:]
    else
        A = A0[3:4,:]
    end
    descA = descinit(4, 3, 2, 3, 0, 0, ictxt, 2)

    # dgeqrf(m, n, A, ia, ja, desca, tau, work, lwork, info)
    tau = zeros(3)
    work = zeros(1)
    info = Ref{Cint}(-1)
    pdgeqrf!(4, 3, A, 1, 1, descA, tau, work, -1, info)
    @test info[] == 0
    lwork = Cint(work[1])
    work = zeros(lwork)
    pdgeqrf!(4, 3, A, 1, 1, descA, tau, work, lwork, info)
    @test info[] == 0

    if mypnum == 0
        @test A ≈ HR0[1:2,:]
    else
        @test A ≈ HR0[3:4,:]
    end
    @test tau ≈ tau0

    blacs_gridexit(ictxt)
end

function test_pdorgqr!()
    ictxt = sl_init(2, 1)
    mypnum >= 2 && return

    if mypnum == 0
        A = deepcopy(HR0[1:2,:])
    else
        A = deepcopy(HR0[3:4,:])
    end
    tau = deepcopy(tau0)
    descA = descinit(4, 3, 2, 3, 0, 0, ictxt, 2)

    # pdorgqr!(m, n, k, A, ia, ja, desca, tau, work, lwork, info)
    work = zeros(1)
    info = Ref{Cint}(-1)
    pdorgqr!(4, 3, 3, A, 1, 1, descA, tau, work, -1, info)
    @test info[] == 0
    lwork = Cint(work[1])
    work = zeros(lwork)
    pdorgqr!(4, 3, 3, A, 1, 1, descA, tau, work, lwork, info)
    @test info[] == 0

    if mypnum == 0
        @test A ≈ Q0[1:2,:]
    else
        @test A ≈ Q0[3:4,:]
    end

    blacs_gridexit(ictxt)
end

function test_pdormqr!()
    ictxt = sl_init(2, 1)
    mypnum >= 2 && return

    if mypnum == 0
        A = deepcopy(HR0[1:2,:])
        C = deepcopy(C0[1:2,:])
    else
        A = deepcopy(HR0[3:4,:])
        C = deepcopy(C0[3:4,:])
    end
    tau = deepcopy(tau0)
    descA = descinit(4, 3, 2, 3, 0, 0, ictxt, 2)
    descC = descinit(4, 2, 2, 2, 0, 0, ictxt, 2)

    # pdormqr!(side, trans, m, n, k, A, ia, ja, desca,
    #     tau, C, ic, jc, descc, work, lwork, info)
    work = zeros(1)
    info = Ref{Cint}(-1)
    pdormqr!('L', 'T', 4, 2, 3, A, 1, 1, descA, tau, C, 1, 1, descC, work, -1, info)
    @test info[] == 0
    lwork = Cint(work[1])
    work = zeros(lwork)
    pdormqr!('L', 'T', 4, 2, 3, A, 1, 1, descA, tau, C, 1, 1, descC, work, lwork, info)
    @test info[] == 0

    if mypnum == 0
        @test C ≈ QC0[1:2,:]
    else
        @test C ≈ QC0[3:4,:]
    end

    blacs_gridexit(ictxt)
end

function test_pdtrtrs!()
    ictxt = sl_init(2, 1)
    mypnum >= 2 && return

    if mypnum == 0
        A = deepcopy(HR0[1:2,:])
        C = deepcopy(QC0[1:2,:])
    else
        A = deepcopy(HR0[3:4,:])
        C = deepcopy(QC0[3:4,:])
    end
    descA = descinit(4, 3, 2, 2, 0, 0, ictxt, 2)
    descC = descinit(4, 2, 2, 2, 0, 0, ictxt, 2)

    # pdtrtrs(uplo, trans, diag, n, nrhs, A, ia, ja, desca, B, ib, jb, descb, info)
    info = Ref{Cint}(-1)
    pdtrtrs!('U', 'N', 'N', 3, 2, A, 1, 1, descA, C, 1, 1, descC, info)
    @test info[] == 0

    if mypnum == 0
        @test C ≈ X0[1:2,:]
    else
        @test C[1,:] ≈ X0[3,:]
    end

    blacs_gridexit(ictxt)
end

@testset "pdgeqrf!" begin
    test_pdgeqrf!()
end

@testset "pdorgqr!" begin
    test_pdorgqr!()
end

@testset "pdormqr!" begin
    test_pdormqr!()
end

@testset "pdtrtrs!" begin
    test_pdtrtrs!()
end
