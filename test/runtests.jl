using MPI, Test

nprocs = 2

testdir = @__DIR__
files = ["test_blacs.jl"]

for file in files
    mpiexec() do mpirun
        path = joinpath(testdir, file)
        cmd = `$mpirun -n $nprocs $(Base.julia_cmd()) $path`
        run(cmd)
    end
end
