# SUBROUTINE PDGEQRF( M, N, A, IA, JA, DESCA, TAU, WORK, LWORK, INFO )
function pdgeqrf!(m::Integer, n::Integer, A::Array{Float64}, ia::Integer, ja::Integer,
        desca::Vector{Cint}, tau::Vector{Float64}, work::Vector{Float64}, lwork::Integer,
        info::Ref{Cint})
    ccall((:pdgeqrf_, libscalapack), Cvoid,
        (Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Float64},
        Ref{Float64}, Ref{Cint}, Ref{Cint}),
        m, n, A, ia, ja, desca, tau, work, lwork, info)
end

# SUBROUTINE PDORGQR( M, N, K, A, IA, JA, DESCA, TAU, WORK, LWORK, INFO )
function pdorgqr!(m::Integer, n::Integer, k::Integer, A::Array{Float64}, ia::Integer,
        ja::Integer, desca::Vector{Cint}, tau::Vector{Float64}, work::Vector{Float64},
        lwork::Integer, info::Ref{Cint})
    ccall((:pdorgqr_, libscalapack), Cvoid,
        (Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint},
        Ref{Float64}, Ref{Float64}, Ref{Cint}, Ref{Cint}),
        m, n, k, A, ia, ja, desca, tau, work, lwork, info)
end

# SUBROUTINE PDORMQR( SIDE, TRANS, M, N, K, A, IA, JA, DESCA, TAU,
# $                    C, IC, JC, DESCC, WORK, LWORK, INFO )
function pdormqr!(side::Char, trans::Char, m::Integer, n::Integer, k::Integer,
        A::Array{Float64}, ia::Integer, ja::Integer, desca::Vector{Cint},
        tau::Vector{Float64}, C::Array{Float64}, ic::Integer, jc::Integer,
        descc::Vector{Cint}, work::Vector{Float64}, lwork::Integer, info::Ref{Cint})
    ccall((:pdormqr_, libscalapack), Cvoid,
        (Ref{UInt8}, Ref{UInt8}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Cint},
        Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint},
        Ref{Float64}, Ref{Cint}, Ref{Cint}),
        side, trans, m, n, k, A, ia, ja, desca, tau, C, ic, jc, descc, work, lwork, info)
end

# SUBROUTINE PDTRTRS( UPLO, TRANS, DIAG, N, NRHS, A, IA, JA, DESCA,
# $                    B, IB, JB, DESCB, INFO )
function pdtrtrs!(uplo::Char, trans::Char, diag::Char, n::Integer, nrhs::Integer,
        A::Array{Float64}, ia::Integer, ja::Integer, desca::Vector{Cint},
        B::Array{Float64}, ib::Integer, jb::Integer, descb::Vector{Cint}, info::Ref{Cint})
    ccall((:pdtrtrs_, libscalapack), Cvoid,
        (Ref{UInt8}, Ref{UInt8}, Ref{UInt8}, Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Cint},
        Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}),
        uplo, trans, diag, n, nrhs, A, ia, ja, desca, B, ib, jb, descb, info)
end
