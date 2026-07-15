#include <cmath>
#include <iomanip>
#include <iostream>
#include <vector>

static long double entropy(const std::vector<long double>& p) {
    long double h = 0.0L;
    for (long double x : p) {
        if (x > 0.0L) h -= x * std::log(x);
    }
    return h;
}

int main() {
    // Demonstrates that entropy/multiplicity loss from a small directional
    // imbalance is quadratic in velocity.
    //
    // Case A: pure one-dimensional balanced pair.
    //   p_R = 1/2 + v/2
    //   p_L = 1/2 - v/2
    //   H0 - H(v) ~= (1/2) v^2.
    //
    // Case B: six-direction taxicab list with other directions present.
    //   p_R = 1/6 + v_x/2
    //   p_L = 1/6 - v_x/2
    //   H0 - H(v_x) ~= (3/2) v_x^2.

    const long double H0_pair = std::log(2.0L);
    const long double H0_six = std::log(6.0L);
    const std::vector<long double> velocities = {
        0.001L,
        0.002L,
        0.005L,
        0.01L,
        0.02L,
        0.05L,
        0.10L,
        0.20L,
        0.30L,
    };

    std::cout << std::setprecision(18);
    std::cout
        << "v,"
        << "pair_entropy_loss,"
        << "pair_loss_over_v2,"
        << "pair_prediction_0p5v2,"
        << "six_entropy_loss,"
        << "six_loss_over_v2,"
        << "six_prediction_1p5v2\n";

    for (long double v : velocities) {
        std::vector<long double> pair = {
            1.0L / 2.0L + v / 2.0L,
            1.0L / 2.0L - v / 2.0L,
        };
        std::vector<long double> six = {
            1.0L / 6.0L + v / 2.0L,
            1.0L / 6.0L - v / 2.0L,
            1.0L / 6.0L,
            1.0L / 6.0L,
            1.0L / 6.0L,
            1.0L / 6.0L,
        };
        const long double pair_loss = H0_pair - entropy(pair);
        const long double six_loss = H0_six - entropy(six);
        std::cout
            << static_cast<double>(v) << ","
            << static_cast<double>(pair_loss) << ","
            << static_cast<double>(pair_loss / (v * v)) << ","
            << static_cast<double>(0.5L * v * v) << ","
            << static_cast<double>(six_loss) << ","
            << static_cast<double>(six_loss / (v * v)) << ","
            << static_cast<double>(1.5L * v * v) << "\n";
    }

    return 0;
}
