# ScaLAPACK

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://sideboard.github.io/ScaLAPACK.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://sideboard.github.io/ScaLAPACK.jl/dev/)
[![Build Status](https://github.com/Sideboard/ScaLAPACK.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Sideboard/ScaLAPACK.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

This package provides Julia wrappers for ScaLAPACK, BLACS, and PBLAS routines, including redistribution and tools. It can solve linear algebra problems distributed among several cores and compute nodes.

The main goal is to give access to the mentioned system libraries of compute clusters instead of relying on external ones.

## Available Features

- Singular value decomposition (SVD)
- QR decomposition

## Restrictions

This is early work in progress. See the GitHub page for current developments.

### Libraries

- Confirmed working with `libscalapack` on Cent OS 8 Stream and `libscalapack-openmpi` on Ubuntu 20.04 LTS.
- Support for Intel OneAPI is under development.

### Contents

- Only the double precision routines (`pd…`) have been included for now.
- Only the basic wrappers are available for now, no convenience methods.
- There is no type combining matrices and their descriptor vectors yet.

## Usage

- `JULIA_SCALAPACK_LIBRARY` (`libscalapack`) Sets the name (or path) of the shared library file to look for.
## Examples

Assuming the necessary libraries have been installed, you can use the provided examples (see `example` directory) to check usage on your system. The examples generate their local matrices in a way that the combined global matrix is identical for any process distribution so that results can be compared.

```bash
# On CentOS 8 Stream
module add mpi/openmpi-x86_64
cd ScaLAPACK.jl/example
mpirun -n 2 julia qr.jl --afile A --bfile B --xfile X --nrows 1000 --ncols 100
```

```bash
# On Ubuntu 20.04 LTS
export JULIA_SCALAPACK_LIBRARY=libscalapack-openmpi
cd ScaLAPACK.jl/example
mpirun -n 2 julia qr.jl --afile A --bfile B --xfile X --nrows 1000 --ncols 100
```
