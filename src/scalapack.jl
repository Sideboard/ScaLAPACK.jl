# SUBROUTINE PDGEBRD( M, N, A, IA, JA, DESCA, D, E, TAUQ, TAUP, WORK, LWORK, INFO )
function pdgebrd!(m::Integer, n::Integer, A::Array{Float64}, ia::Integer, ja::Integer,
        desca::Vector{Cint}, d::Vector{Float64}, e::Vector{Float64}, tauq::Vector{Float64},
        taup::Vector{Float64}, work::Vector{Float64}, lwork::Integer, info::Ref{Cint})
    ccall((:pdgebrd_, libscalapack), Cvoid,
        (Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Float64},
        Ref{Float64}, Ref{Float64}, Ref{Float64}, Ref{Float64}, Ref{Cint}, Ref{Cint}),
        m, n, A, ia, ja, desca, d, e, tauq, taup, work, lwork, info)
end

# SUBROUTINE PDGEQRF( M, N, A, IA, JA, DESCA, TAU, WORK, LWORK, INFO )
function pdgeqrf!(m::Integer, n::Integer, A::Array{Float64}, ia::Integer, ja::Integer,
        desca::Vector{Cint}, tau::Vector{Float64}, work::Vector{Float64}, lwork::Integer,
        info::Ref{Cint})
    ccall((:pdgeqrf_, libscalapack), Cvoid,
        (Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Float64},
        Ref{Float64}, Ref{Cint}, Ref{Cint}),
        m, n, A, ia, ja, desca, tau, work, lwork, info)
end

# SUBROUTINE PDGESVD( JOBU, JOBVT, M, N, A, IA, JA, DESCA, S, U, IU, JU, DESCU,
# $                    VT, IVT, JVT, DESCVT, WORK, LWORK, INFO )
function pdgesvd!(jobu::Char, jobvt::Char, m::Integer, n::Integer, A::Array{Float64},
        ia::Integer, ja::Integer, desca::Vector{Cint}, s::Vector{Float64},
        U::Array{Float64}, iu::Integer, ju::Integer, descu::Vector{Cint},
        VT::Array{Float64}, ivt::Integer, jvt::Integer, descvt::Vector{Cint},
        work::Vector{Float64}, lwork::Integer, info::Ref{Cint})
    ccall((:pdgesvd_, libscalapack), Cvoid,
        (Ref{UInt8}, Ref{UInt8}, Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Cint}, Ref{Cint},
        Ref{Cint}, Ref{Float64}, Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint},
        Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Cint}, Ref{Cint}),
        jobu, jobvt, m, n, A, ia, ja, desca, s, U, iu, ju, descu, VT, ivt, jvt, descvt,
        work, lwork, info)
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
