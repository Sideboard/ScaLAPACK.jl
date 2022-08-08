# void pdgemr2d_(Int *m, Int *n, double *A, Int *ia, Int *ja, Int desc_A[9],
#                double *B, Int *ib, Int *jb, Int desc_B[9], Int *gcontext)
function pdgemr2d!(m::Integer, n::Integer, A::Matrix{Float64}, ia::Integer, ja::Integer,
        desca::Vector{Cint}, B::Matrix{Float64}, ib::Integer, jb::Integer,
        descb::Vector{Cint}, ictxt::Integer)
    ccall((:pdgemr2d_, libscalapack), Cvoid,
        (Ref{Cint}, Ref{Cint}, Ref{Float64}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Float64},
        Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}),
        m, n, A, ia, ja, desca, B, ib, jb, descb, ictxt)
end
