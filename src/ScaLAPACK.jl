module ScaLAPACK

import Libdl: find_library  # explicit import backwards compatibility

export libscalapack, libblacs
export ScaLAPACKError

export blacs_exit, blacs_get!, blacs_get, blacs_gridexit, blacs_gridinfo!, blacs_gridinfo,
    blacs_gridinit, blacs_pinfo!, blacs_pinfo, blacs_setup!, blacs_setup
export descinit!, descinit, indxg2l, indxg2p, indxl2g, numroc, sl_init!, sl_init
export pdgemr2d!
export pdgemm!, pdtrmm!
export pdgebrd!, pdgeqrf!, pdgesvd!, pdorgqr!, pdormqr!, pdtrtrs!


const libscalapack_name = get(ENV, "JULIA_SCALAPACK_LIBRARY", "libscalapack")
const libscalapack = find_library(libscalapack_name)
libscalapack == "" && error("ScaLAPACK library $libscalapack_name not found")

const libblacs_name = get(ENV, "JULIA_BLACS_LIBRARY", libscalapack_name)
const libblacs = find_library(libblacs_name)  # differs for Intel/MKL
libblacs == "" && error("BLACS library $libblacs_name not found")


include("error.jl")

include("blacs.jl")
include("tools.jl")
include("redist.jl")
include("pblas.jl")
include("scalapack.jl")

end
