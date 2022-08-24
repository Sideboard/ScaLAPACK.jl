include("common.jl")

@testset "ScaLAPACK" begin

    @testset "QR" begin
        include("test_scalapack_qr.jl")
    end

    @testset "SVD" begin
        include("test_scalapack_svd.jl")
    end

    blacs_exit(0)
end
