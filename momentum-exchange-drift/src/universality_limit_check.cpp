#include <cmath>
#include <iomanip>
#include <iostream>
#include <vector>

// This small check is not a physical simulation of photons.
// It compares two large-count response factors:
//
// 1. Matter-like add/remove denominator asymmetry:
//        g_matter(N) = N^2 * E[Delta v_display | k=0]
//                    = N^2 / (N^2 - 1)
//    which tends to 1.
//
// 2. Photon-like packet response:
//        number of available carrier components ~ Ngamma
//        turn per component ~ 1/Ngamma
//        g_packet(Ngamma) = Ngamma * (1/Ngamma)
//                         = 1.
//
// If both are driven by the same source-side carrier flux and the same unit
// impulse convention, these dimensionless response factors have the same
// large-count limit. This does not derive G; it states the condition under
// which matter response and photon-like transverse response can share the same
// effective coupling.

int main() {
    std::vector<long double> counts = {
        10.0L,
        100.0L,
        1000.0L,
        10000.0L,
        1000000.0L,
        1000000000.0L
    };

    std::cout << std::setprecision(18);
    std::cout << "N,g_matter=N^2/(N^2-1),matter_error,g_packet=N*(1/N)\n";

    for (long double N : counts) {
        long double g_matter = (N * N) / (N * N - 1.0L);
        long double matter_error = g_matter - 1.0L;
        long double g_packet = N * (1.0L / N);

        std::cout
            << static_cast<double>(N) << ","
            << static_cast<double>(g_matter) << ","
            << static_cast<double>(matter_error) << ","
            << static_cast<double>(g_packet) << "\n";
    }

    return 0;
}
