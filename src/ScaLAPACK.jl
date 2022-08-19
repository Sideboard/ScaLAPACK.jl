module ScaLAPACK

using Libdl  # import Libdl for backwards compatibility


export libblacs, libscalapack, dlopen_flags, lib_handles
export ScaLAPACKError

export blacs_exit, blacs_get!, blacs_get, blacs_gridexit, blacs_gridinfo!, blacs_gridinfo,
    blacs_gridinit, blacs_pinfo!, blacs_pinfo, blacs_setup!, blacs_setup
export descinit!, descinit, numroc, sl_init!, sl_init
export pdgemr2d!
export pdgemm!, pdtrmm!
export pdgeqrf!, pdorgqr!, pdormqr!, pdtrtrs!


const lib_handles = []
const dlopen_flags = RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL

# calls will use dlopened libs instead, set stubs to keep calls the same
const libblacs = ""
const libscalapack = ""

function __init__()
    libscalapack = get(ENV, "JULIA_SCALAPACK_LIBRARY", "libscalapack")
    libblacs = get(ENV, "JULIA_SCALAPACK_BLACS_LIBRARY", libscalapack)

    preload_libs = get(ENV, "JULIA_SCALAPACK_PRELOAD_LIBRARIES", "")
    preload_libs = split(preload_libs, ":")
    for libpreload in preload_libs
        isempty(libpreload) && continue
        handle = dlopen(libpreload, dlopen_flags)
        push!(lib_handles, handle)
    end

    libblacs_handle = dlopen(libblacs, dlopen_flags)
    push!(lib_handles, libblacs_handle)
    libscalapack_handle = dlopen(libscalapack, dlopen_flags)
    push!(lib_handles, libscalapack_handle)
end

include("error.jl")

include("blacs.jl")
include("tools.jl")
include("redist.jl")
include("pblas.jl")
include("scalapack.jl")

end
