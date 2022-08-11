using MPI, Test

@show MPI.MPI_LIBRARY_VERSION_STRING

nprocs = 2

testdir = @__DIR__
files = [
    "test_blacs.jl",
    "test_tools.jl",
    "test_redist.jl",
    "test_pblas.jl",
    "test_scalapack.jl",
    ]

function run_with_timeout(cmd, timeout::Integer = 5)
    proc = run(cmd; wait=false)
    for i in 1:timeout
        !process_running(proc) && return proc
        sleep(1)
    end
    kill(proc)
    return proc
end

for file in files
    mpiexec() do mpirun
        path = joinpath(testdir, file)
        cmd = `$mpirun -n $nprocs $(Base.julia_cmd()) $path`
        proc = run_with_timeout(cmd, 20)
        @test proc.exitcode == 0
    end
end
