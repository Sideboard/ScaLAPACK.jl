# void pdgemm_( TRANSA, TRANSB, M, N, K, ALPHA, A, IA, JA, DESCA,
#               B, IB, JB, DESCB, BETA, C, IC, JC, DESCC )
#    F_CHAR_T       TRANSA, TRANSB;
#    Int            * IA, * IB, * IC, * JA, * JB, * JC, * K, * M, * N;
#    double         * ALPHA, * BETA;
#    Int            * DESCA, * DESCB, * DESCC;
#    double         * A, * B, * C;
function pdgemm!(transa::Char, transb::Char, m::Integer, n::Integer, k::Integer,
        alpha::Float64, A::Array{Float64}, ia::Integer, ja::Integer, desca::Vector{Cint},
        B::Array{Float64}, ib::Integer, jb::Integer, descb::Vector{Cint}, beta::Float64,
        C::Array{Float64}, ic::Integer, jc::Integer, descc::Vector{Cint})
    ccall((:pdgemm_, libscalapack), Cvoid,
        (Ref{Cuchar}, Ref{Cuchar}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Float64},
        Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Cint}, Ref{Cint},
        Ref{Cint}, Ref{Float64}, Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint}),
        transa, transb, m, n, k, alpha, A, ia, ja, desca, B, ib, jb, descb, beta, C, ic, jc,
        descc)
end

# void pdtrmm_( SIDE, UPLO, TRANS, DIAG, M, N, ALPHA,
#               A, IA, JA, DESCA, B, IB, JB, DESCB )
#    F_CHAR_T       DIAG, SIDE, TRANS, UPLO;
#    Int            * IA, * IB, * JA, * JB, * M, * N;
#    double         * ALPHA;
#    Int            * DESCA, * DESCB;
#    double         * A, * B;
function pdtrmm!(side::Char, uplo::Char, transa::Char, diag::Char, m::Integer, n::Integer,
    alpha::Float64, A::Array{Float64}, ia::Integer, ja::Integer, desca::Vector{Cint},
    B::Array{Float64}, ib::Integer, jb::Integer, descb::Vector{Cint})
ccall((:pdtrmm_, libscalapack), Cvoid,
    (Ref{Cuchar}, Ref{Cuchar}, Ref{Cuchar}, Ref{Cuchar}, Ref{Cint}, Ref{Cint},
    Ref{Float64}, Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Float64},
    Ref{Cint}, Ref{Cint}, Ref{Cint}),
    side, uplo, transa, diag, m, n, alpha, A, ia, ja, desca, B, ib, jb, descb)
end
