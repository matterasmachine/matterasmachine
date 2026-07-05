#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <random>
#include <vector>

struct Result {
  double mean_a;
  double mean_b;
  double flux;
  double tv_exact;
  double tv_geometric;
  double tau_int;
  double effective_samples;
};

std::pair<double, double> autocorrelation_diagnostics(const std::vector<double>& x) {
  const int count = static_cast<int>(x.size());
  double mean = 0.0;
  for (double value : x) mean += value;
  mean /= count;
  double variance = 0.0;
  for (double value : x) variance += (value - mean) * (value - mean);
  variance /= count;
  double tau = 0.5;
  if (variance > 0.0) {
    for (int lag = 1; lag < count / 2; ++lag) {
      double covariance = 0.0;
      for (int t = 0; t < count - lag; ++t)
        covariance += (x[t] - mean) * (x[t + lag] - mean);
      covariance /= count - lag;
      const double rho = covariance / variance;
      if (rho <= 0.0) break;
      tau += rho;
    }
  }
  return {tau, count / (2.0 * tau)};
}

std::vector<long double> exact_marginal(int Q, int M) {
  std::vector<long double> p(Q + 1, 0.0L);
  p[0] = static_cast<long double>(M - 1) / (Q + M - 1);
  for (int m = 0; m < Q; ++m) {
    p[m + 1] = p[m] * static_cast<long double>(Q - m) /
               static_cast<long double>(Q - m + M - 2);
  }
  return p;
}

double tv_distance(const std::vector<std::uint64_t>& histogram,
                   std::uint64_t samples,
                   const std::vector<long double>& target) {
  long double difference = 0.0L;
  for (std::size_t m = 0; m < target.size(); ++m) {
    const long double observed =
        m < histogram.size() ? static_cast<long double>(histogram[m]) / samples : 0.0L;
    difference += std::abs(observed - target[m]);
  }
  return static_cast<double>(0.5L * difference);
}

Result run(std::uint64_t seed) {
  constexpr int per_bath = 1000;
  constexpr int M = 2 * per_bath;
  constexpr int Q = 9000;
  constexpr std::int64_t burn_in = 5'000'000;
  constexpr std::int64_t measured_steps = 20'000'000;
  constexpr std::int64_t sample_every = 20'000;

  std::mt19937_64 rng(seed);
  std::vector<int> occupancy(M, 0);
  for (int q = 0; q < 8000; ++q) ++occupancy[rng() % per_bath];
  for (int q = 0; q < 1000; ++q) ++occupancy[per_bath + rng() % per_bath];

  std::uniform_int_distribution<int> pick(0, M - 1);
  std::vector<std::uint64_t> histogram(Q + 1, 0);
  std::uint64_t histogram_samples = 0;
  long double accumulated_a = 0.0L;
  long double accumulated_b = 0.0L;
  std::uint64_t snapshots = 0;
  std::vector<double> mean_a_series;
  std::int64_t net_a_to_b = 0;
  std::int64_t cross_attempts = 0;

  for (std::int64_t step = 1; step <= burn_in + measured_steps; ++step) {
    const int donor = pick(rng);
    int receiver = pick(rng);
    while (receiver == donor) receiver = pick(rng);
    const bool cross = (donor < per_bath) != (receiver < per_bath);
    if (step > burn_in && cross) ++cross_attempts;
    if (occupancy[donor] > 0) {
      --occupancy[donor];
      ++occupancy[receiver];
      if (step > burn_in && cross) net_a_to_b += donor < per_bath ? 1 : -1;
    }
    if (step > burn_in && (step - burn_in) % sample_every == 0) {
      std::int64_t qa = 0;
      for (int i = 0; i < per_bath; ++i) qa += occupancy[i];
      accumulated_a += static_cast<long double>(qa) / per_bath;
      accumulated_b += static_cast<long double>(Q - qa) / per_bath;
      ++snapshots;
      mean_a_series.push_back(static_cast<double>(qa) / per_bath);
      for (int m : occupancy) {
        ++histogram[m];
        ++histogram_samples;
      }
    }
  }

  const auto exact = exact_marginal(Q, M);
  const long double nu = static_cast<long double>(Q) / M;
  const long double r = nu / (1.0L + nu);
  std::vector<long double> geometric(Q + 1, 0.0L);
  geometric[0] = 1.0L - r;
  for (int m = 0; m < Q; ++m) geometric[m + 1] = geometric[m] * r;
  const auto diagnostics = autocorrelation_diagnostics(mean_a_series);

  return {
      static_cast<double>(accumulated_a / snapshots),
      static_cast<double>(accumulated_b / snapshots),
      static_cast<double>(net_a_to_b) / cross_attempts,
      tv_distance(histogram, histogram_samples, exact),
      tv_distance(histogram, histogram_samples, geometric),
      diagnostics.first,
      diagnostics.second,
  };
}

int main() {
  constexpr int runs = 8;
  constexpr std::uint64_t first_seed = 2026070403ULL;
  std::vector<Result> results;
  std::cout << "seed mean_A mean_B net_flux TV_exact TV_geometric tau_int ESS\n"
            << std::fixed << std::setprecision(6);
  for (int run_index = 0; run_index < runs; ++run_index) {
    const auto seed = first_seed + run_index;
    results.push_back(run(seed));
    const auto& x = results.back();
    std::cout << seed << ' ' << x.mean_a << ' ' << x.mean_b << ' ' << x.flux
              << ' ' << x.tv_exact << ' ' << x.tv_geometric << ' ' << x.tau_int
              << ' ' << x.effective_samples << '\n';
  }

  auto summarize = [&](auto member) {
    long double mean = 0.0L;
    for (const auto& x : results) mean += x.*member;
    mean /= runs;
    long double variance = 0.0L;
    for (const auto& x : results) {
      const long double delta = x.*member - mean;
      variance += delta * delta;
    }
    variance /= runs - 1;
    return std::pair<double, double>{static_cast<double>(mean),
                                     static_cast<double>(std::sqrt(variance))};
  };

  const auto a = summarize(&Result::mean_a);
  const auto b = summarize(&Result::mean_b);
  const auto flux = summarize(&Result::flux);
  const auto exact = summarize(&Result::tv_exact);
  const auto geometric = summarize(&Result::tv_geometric);
  const auto tau = summarize(&Result::tau_int);
  const auto ess = summarize(&Result::effective_samples);
  std::cout << "mean_sd " << a.first << ' ' << a.second << ' ' << b.first << ' '
            << b.second << ' ' << flux.first << ' ' << flux.second << ' '
            << exact.first << ' ' << exact.second << ' ' << geometric.first << ' '
            << geometric.second << ' ' << tau.first << ' ' << tau.second << ' '
            << ess.first << ' ' << ess.second << '\n';
}
