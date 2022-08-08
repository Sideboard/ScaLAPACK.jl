using MPI, Test

nprocs = 2

testdir = @__DIR__
files = [
    "test_blacs.jl",
    "test_tools.jl",
    "test_redist.jl",
    "test_pblas.jl",
    ]

for file in files
    mpiexec() do mpirun
        path = joinpath(testdir, file)
        cmd = `$mpirun -n $nprocs $(Base.julia_cmd()) $path`
        proc = run(cmd)
        @test proc.exitcode == 0
    end
end
