#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <random>
#include <string>
#include <vector>

struct Config {
    std::string label;
    int64_t N;
    int walkers;
    int ticks;
    int runs;
};

struct RunResult {
    double display_mean_x;
    double display_median_x;
    double display_mean_v;
    double display_median_v;
    double mean_k;
};

static double mean(const std::vector<double>& values) {
    if (values.empty()) return 0.0;
    long double sum = 0.0L;
    for (double v : values) sum += v;
    return static_cast<double>(sum / values.size());
}

static double median(std::vector<double> values) {
    if (values.empty()) return 0.0;
    std::sort(values.begin(), values.end());
    const size_t mid = values.size() / 2;
    if (values.size() % 2 == 1) return values[mid];
    return 0.5 * (values[mid - 1] + values[mid]);
}

static double sample_sd(const std::vector<double>& values) {
    if (values.size() < 2) return 0.0;
    const double m = mean(values);
    long double sum = 0.0L;
    for (double v : values) {
        const long double d = static_cast<long double>(v) - m;
        sum += d * d;
    }
    return static_cast<double>(std::sqrt(sum / (values.size() - 1)));
}

static RunResult run_one(const Config& cfg, std::mt19937_64& rng) {
    std::bernoulli_distribution coin(0.5);
    std::vector<int64_t> k(cfg.walkers, 0);
    std::vector<double> v(cfg.walkers, 0.0);
    std::vector<double> x(cfg.walkers, 0.0);

    for (int t = 0; t < cfg.ticks; ++t) {
        for (int i = 0; i < cfg.walkers; ++i) {
            if (coin(rng)) {
                k[i] += 1;
                const int64_t denom = std::max<int64_t>(1, cfg.N - k[i]);
                v[i] -= 1.0 / static_cast<double>(denom);
            } else {
                k[i] -= 1;
                const int64_t denom = std::max<int64_t>(1, cfg.N - k[i]);
                v[i] += 1.0 / static_cast<double>(denom);
            }
            x[i] += v[i];
        }
    }

    std::vector<double> kd(cfg.walkers);
    for (int i = 0; i < cfg.walkers; ++i) kd[i] = static_cast<double>(k[i]);

    // The UI option "attraction is +x" displays -x and -v.
    return {
        -mean(x),
        -median(x),
        -mean(v),
        -median(v),
        mean(kd),
    };
}

int main() {
    const std::vector<Config> configs = {
        {"small-N visible signal", 1000, 8000, 5000, 30},
        {"UI-like medium run", 10000, 8000, 20000, 16},
        {"large-N weak signal", 100000, 8000, 20000, 16},
        {"larger ensemble check", 10000, 20000, 20000, 8},
    };

    std::mt19937_64 rng(0xA11C1C20260712ULL);

    std::cout << std::setprecision(10);
    std::cout << "Rule under test:\n";
    std::cout << "  if coin: k += 1; v -= 1/(N-k)\n";
    std::cout << "  else:    k -= 1; v += 1/(N-k)\n";
    std::cout << "  x += v\n";
    std::cout << "Displayed attraction direction is -x, -v.\n\n";

    for (const Config& cfg : configs) {
        int positive_mean_x = 0;
        int positive_median_x = 0;
        int positive_mean_v = 0;
        long double sum_mean_x = 0.0L;
        long double sum_median_x = 0.0L;
        long double sum_mean_v = 0.0L;
        long double sum_median_v = 0.0L;
        long double sum_k = 0.0L;
        std::vector<double> run_mean_x;
        std::vector<double> run_mean_v;
        run_mean_x.reserve(cfg.runs);
        run_mean_v.reserve(cfg.runs);

        for (int r = 0; r < cfg.runs; ++r) {
            const RunResult out = run_one(cfg, rng);
            if (out.display_mean_x > 0) positive_mean_x += 1;
            if (out.display_median_x > 0) positive_median_x += 1;
            if (out.display_mean_v > 0) positive_mean_v += 1;
            sum_mean_x += out.display_mean_x;
            sum_median_x += out.display_median_x;
            sum_mean_v += out.display_mean_v;
            sum_median_v += out.display_median_v;
            sum_k += out.mean_k;
            run_mean_x.push_back(out.display_mean_x);
            run_mean_v.push_back(out.display_mean_v);
        }

        const double expected_v =
            static_cast<double>(cfg.ticks) /
            static_cast<double>(cfg.N * cfg.N);
        const double expected_x =
            static_cast<double>(cfg.ticks) *
            static_cast<double>(cfg.ticks + 1) /
            (2.0 * static_cast<double>(cfg.N * cfg.N));

        std::cout << "CONFIG: " << cfg.label << "\n";
        std::cout << "  N=" << cfg.N
                  << " walkers=" << cfg.walkers
                  << " ticks=" << cfg.ticks
                  << " runs=" << cfg.runs << "\n";
        std::cout << "  positive mean x runs:   "
                  << positive_mean_x << "/" << cfg.runs << "\n";
        std::cout << "  positive median x runs: "
                  << positive_median_x << "/" << cfg.runs << "\n";
        std::cout << "  positive mean v runs:   "
                  << positive_mean_v << "/" << cfg.runs << "\n";
        std::cout << "  avg displayed mean x:   "
                  << static_cast<double>(sum_mean_x / cfg.runs)
                  << "  theory ~ " << expected_x
                  << "  sem " << sample_sd(run_mean_x) / std::sqrt(cfg.runs)
                  << "\n";
        std::cout << "  avg displayed median x: "
                  << static_cast<double>(sum_median_x / cfg.runs) << "\n";
        std::cout << "  avg displayed mean v:   "
                  << static_cast<double>(sum_mean_v / cfg.runs)
                  << "  theory ~ " << expected_v
                  << "  sem " << sample_sd(run_mean_v) / std::sqrt(cfg.runs)
                  << "\n";
        std::cout << "  avg displayed median v: "
                  << static_cast<double>(sum_median_v / cfg.runs) << "\n";
        std::cout << "  avg final k:            "
                  << static_cast<double>(sum_k / cfg.runs) << "\n\n";
        std::cout.flush();
    }

    return 0;
}
