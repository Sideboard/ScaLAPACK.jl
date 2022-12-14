# SUBROUTINE DESCINIT( DESC, M, N, MB, NB, IRSRC, ICSRC, ICTXT, LLD, INFO )
function descinit!(desc::Vector{Cint}, m::Integer, n::Integer, mb::Integer, nb::Integer,
        irsrc::Integer, icsrc::Integer, ictxt::Integer, lld::Integer, info::Ref{Cint})
    ccall((:descinit_, libscalapack), Cvoid,
          (Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint},
          Ref{Cint}, Ref{Cint}, Ref{Cint}),
          desc, m, n, mb, nb, irsrc, icsrc, ictxt, lld, info)
end

function descinit(m::Integer, n::Integer, mb::Integer, nb::Integer, irsrc::Integer,
        icsrc::Integer, ictxt::Integer, lld::Integer)
    desc = fill(Cint(-1), 9)
    info = Ref{Cint}(0)
    descinit!(desc, m, n, mb, nb, irsrc, icsrc, ictxt, lld, info)
    info[] != 0 && throw(ScaLAPACKError(info[]))
    return desc
end

# INTEGER FUNCTION INDXG2L( INDXGLOB, NB, IPROC, ISRCPROC, NPROCS )
function indxg2l(indxglob, nb, iproc, isrcproc, nprocs)
    ccall((:indxg2l_, libscalapack), Cint,
        (Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}),
        indxglob, nb, iproc, isrcproc, nprocs)
end

# INTEGER FUNCTION INDXG2P( INDXGLOB, NB, IPROC, ISRCPROC, NPROCS )
function indxg2p(indxglob, nb, iproc, isrcproc, nprocs)
    ccall((:indxg2p_, libscalapack), Cint,
        (Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}),
        indxglob, nb, iproc, isrcproc, nprocs)
end

# INTEGER FUNCTION INDXL2G( INDXLOC, NB, IPROC, ISRCPROC, NPROCS )
function indxl2g(indxloc, nb, iproc, isrcproc, nprocs)
    ccall((:indxl2g_, libscalapack), Cint,
        (Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}),
        indxloc, nb, iproc, isrcproc, nprocs)
end

# INTEGER FUNCTION NUMROC( N, NB, IPROC, ISRCPROC, NPROCS )
function numroc(n, nb, iproc, isrcproc, nprocs)
    ccall((:numroc_, libscalapack), Cint,
        (Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}),
        n, nb, iproc, isrcproc, nprocs)
end

# SUBROUTINE SL_INIT( ICTXT, NPROW, NPCOL )
function sl_init!(ictxt::Ref{Cint}, nprow::Integer, npcol::Integer)
    ccall((:sl_init_, libscalapack), Cvoid,
          (Ref{Cint}, Ref{Cint}, Ref{Cint}),
          ictxt, nprow, npcol)
end

function sl_init(nprow::Integer, npcol::Integer)
    ictxt = Ref{Cint}(-1)
    sl_init!(ictxt, nprow, npcol)
    return ictxt[]
end
