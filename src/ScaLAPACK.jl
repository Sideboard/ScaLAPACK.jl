module ScaLAPACK

export libscalapack, libblacs

export blacs_exit, blacs_get!, blacs_get, blacs_gridexit, blacs_gridinfo!, blacs_gridinfo,
    blacs_gridinit, blacs_pinfo!, blacs_pinfo, blacs_setup!, blacs_setup

const libscalapack = Libc.find_library("libscalapack")
const libblacs = Libc.find_library("libscalapack")  # differs for Intel/MKL

libscalapack == "" && error("ScaLAPACK library not found")
libblacs == "" && error("BLACS library not found")

include("blacs.jl")

end
