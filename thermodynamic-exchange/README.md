# Thermodynamic Equilibrium from Reversible One-Quantum Exchange

This directory contains the paper source, the rendered PDF, and the simulation
programs used for its closed-equilibrium numerical examples.

## Contents

- `paper/thermodynamic-equilibrium.typ` - editable Typst manuscript.
- `paper/thermodynamic-equilibrium.pdf` - rendered manuscript.
- `src/two_bath_reversible_exchange.cpp` - symmetric nondirectional exchange.
- `src/two_bath_perpendicular_exchange.cpp` - directional perpendicular and
  all-direction controls.
- `Makefile` - build and simulation commands.

The exact equilibrium theorem applies to the symmetric nondirectional Markov
chain. The directional program is a numerical extension with state-dependent
transition weights; the paper claims only approximate agreement for its
reported run.

## Requirements

- A C++17 compiler (`c++`, Clang, or GCC).
- [Typst](https://typst.app/) to rebuild the PDF.

## Reproduce

Build the paper:

```sh
make paper
```

Compile and run both simulations:

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

