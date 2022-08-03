# F_VOID_FUNC blacs_exit_(Int *NotDone)
function blacs_exit(notdone::Integer)
    ccall((:blacs_exit_, libblacs), Cvoid,
        (Ref{Cint},),
        notdone)
end

# F_VOID_FUNC blacs_get_(Int *ConTxt, Int *what, Int *val)
function blacs_get!(contxt::Integer, what::Integer, val::Ref{Cint})
    ccall((:blacs_get_, libblacs), Cvoid,
        (Ref{Cint}, Ref{Cint}, Ref{Cint}),
        contxt, what, val)
end

function blacs_get(contxt::Integer, what::Integer)
    val = Ref{Cint}()
    blacs_get!(contxt, what, val)
    return val[]
end

# F_VOID_FUNC blacs_gridexit_(Int *ConTxt)
function blacs_gridexit(contxt::Integer)
    ccall((:blacs_gridexit_, libblacs), Cvoid,
        (Ref{Cint},),
        contxt)
end

# F_VOID_FUNC blacs_gridinfo_(Int *ConTxt, Int *nprow, Int *npcol,
#                             Int *myrow, Int *mycol)
function blacs_gridinfo!(contxt::Integer, nprow::Ref{Cint}, npcol::Ref{Cint},
        myrow::Ref{Cint}, mycol::Ref{Cint})
    ccall((:blacs_gridinfo_, libblacs), Cvoid,
        (Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint}),
        contxt, nprow, npcol, myrow, mycol)
end

function blacs_gridinfo(contxt::Integer)
    nprow = Ref{Cint}()
    npcol = Ref{Cint}()
    myrow = Ref{Cint}()
    mycol = Ref{Cint}()
    blacs_gridinfo!(contxt, nprow, npcol, myrow, mycol)
    return nprow[], npcol[], myrow[], mycol[]
end

# F_VOID_FUNC blacs_gridinit_(Int *ConTxt, F_CHAR order, Int *nprow, Int *npcol)
function blacs_gridinit(contxt::Integer, order::Char, nprow::Integer, npcol::Integer)
    ccall((:blacs_gridinit_, libblacs), Cvoid,
        (Ref{Cint}, Ref{Cuchar}, Ref{Cint}, Ref{Cint}),
        contxt, order, nprow, npcol)
end

# F_VOID_FUNC blacs_pinfo_(Int *mypnum, Int *nprocs)
function blacs_pinfo!(mypnum::Ref{Cint}, nprocs::Ref{Cint})
    ccall((:blacs_pinfo_, libblacs), Cvoid,
        (Ref{Cint}, Ref{Cint}),
        mypnum, nprocs)
end

function blacs_pinfo()
    mypnum = Ref{Cint}()
    nprocs = Ref{Cint}()
    blacs_pinfo!(mypnum, nprocs)
    return mypnum[], nprocs[]
end

# F_VOID_FUNC blacs_setup_(Int *mypnum, Int *nprocs)
function blacs_setup!(mypnum::Ref{Cint}, nprocs::Ref{Cint})
    ccall((:blacs_setup_, libblacs), Cvoid,
        (Ref{Cint}, Ref{Cint}),
        mypnum, nprocs)
end

function blacs_setup()
    mypnum = Ref{Cint}()
    nprocs = Ref{Cint}()
    blacs_setup!(mypnum, nprocs)
    return mypnum[], mypnum[]
end
