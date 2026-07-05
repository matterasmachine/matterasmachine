# Thermodynamic Equilibrium from Reversible One-Quantum Exchange

This directory contains the paper source, the rendered PDF, and the reversible
exchange simulation used for its closed-equilibrium numerical example.

## Contents

- `paper/thermodynamic-equilibrium.typ` - editable Typst manuscript.
- `paper/thermodynamic-equilibrium.pdf` - rendered manuscript.
- `src/two_bath_reversible_exchange.cpp` - symmetric reversible exchange.
- `Makefile` - build and simulation commands.

The exact equilibrium theorem applies to the symmetric reversible Markov chain.

## Requirements

- A C++17 compiler (`c++`, Clang, or GCC).
- [Typst](https://typst.app/) to rebuild the PDF.

## Reproduce

Build the paper:

```sh
make paper
```

Compile and run the simulation:

```sh
make simulations
make run
```

The programs use fixed pseudorandom seeds, so the reported runs are
deterministic for a given standard-library implementation. Exact output can
still vary across C++ standard-library implementations because their random
distribution algorithms are not required to be bit-for-bit identical.

## Versioning before publication

Create a content-bearing commit after copying these files into the public
repository. Then replace the provisional repository/base-commit paragraph in
the manuscript with the final public URL, tag, and commit hash, and rebuild the
PDF.
