struct ScaLAPACKError <: Exception
    info::Cint
end

function Base.show(io::IO, err::ScaLAPACKError)
    print(io, "ScaLAPACKError($(err.info))")
end
