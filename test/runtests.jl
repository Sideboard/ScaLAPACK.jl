using MPI, Test

@show MPI.MPI_LIBRARY_VERSION_STRING

nprocs = get(ENV, "JULIA_MPI_TEST_NPROCS", 2)

testdir = @__DIR__
files = [
    "test_blacs.jl",
    "test_tools.jl",
    "test_redist.jl",
    "test_pblas.jl",
    "test_scalapack.jl",
    ]

for file in files
    mpiexec() do mpirun
        path = joinpath(testdir, file)
        cmd = `$mpirun -n $nprocs $(Base.julia_cmd()) $path`
        proc = run(cmd)
        @test proc.exitcode == 0
    end
end
