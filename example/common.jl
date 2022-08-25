using Random
using ScaLAPACK

"""
    Create local (ml,nl) matrix of process (myrow,mycol) in a (nprow,npcol) process grid
    that is part of a global (mg,ng) matrix split into cyclicly distributed (mb,nb) blocks.

    The global matrix is identical to calling `rand(mg, ng)` locally.
"""
function prand(mg, ng, mb, nb, ml, nl, nprow, npcol, myrow, mycol; seed=-1)
    A = zeros(ml, nl)
    v = zeros(1)

    seed >= 0 && Random.seed!(seed)
    for jg in 1:ng
        jp = indxg2p(jg, nb, -1, 0, npcol)
        jl = indxg2l(jg, nb, -1, -1, npcol)
        for ig in 1:mg
            ip = indxg2p(ig, mb, -1, 0, nprow)
            il = indxg2l(ig, mb, -1, -1, nprow)
            Random.rand!(v)
            if ip == myrow && jp == mycol
                A[il,jl] = v[1]
            end
        end
    end

    return A
end

function pmatrix_to_file(matrix, prefix, mypnum)
    open("$prefix.$mypnum", "w") do f
        println(f, matrix)
    end
end
