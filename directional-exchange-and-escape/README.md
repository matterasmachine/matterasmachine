# Directional One-Quantum Exchange and Spatial Escape

Reproducibility package for:

> Geometric Endpoint Statistics from Directional One-Quantum Exchange and
> Spatial Escape

## Contents

- `paper/geometric-endpoint-statistics.typ` - editable Typst manuscript.
- `paper/geometric-endpoint-statistics.pdf` - rendered manuscript.
- `src/test_geometric_robustness.cpp` - 30-regime endpoint sweep.
- `src/test_escape_history_weight.cpp` - history-survival analysis.
- `src/predict_endpoints_from_escape_chain.cpp` - held-out absorbing-chain test.
- `src/test_vue_large_n_perpendicular.cpp` - speed and anisotropy diagnostic.
- `web/DirectionalSourceEscape.vue` - interactive Vue 2 implementation.
- `Makefile` - paper and C++ build commands.

## Scope

The constant-hazard benchmark in the paper is exact. The spherical directional
model is numerical and produces only approximately geometric endpoints. The
package does not claim a thermodynamic temperature law, Planck spectrum,
universal speed, or cosmological mechanism.

## Requirements

- A C++17 compiler.
- [Typst](https://typst.app/) to rebuild the paper.
- The Vue component is copied from the larger application and requires a Vue 2
  host project to run interactively.

## Build

```sh
make paper
make simulations
```

Run the four command-line experiments:

```sh
make run
```

The programs use fixed seeds. Exact bitwise output can vary across C++ standard
library implementations because random-distribution algorithms are not required
to be identical.

## Publication version

After committing this directory, replace the provisional reproducibility
paragraph in the manuscript with the repository URL and the new content-bearing
commit hash, then rebuild the PDF.

