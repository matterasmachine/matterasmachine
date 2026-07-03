CXX ?= c++
CXXFLAGS ?= -O3 -std=c++17 -Wall -Wextra -pedantic
BUILD_DIR := build

.PHONY: all paper simulations run clean

all: paper simulations

paper:
	typst compile paper/thermodynamic-equilibrium.typ paper/thermodynamic-equilibrium.pdf

simulations: $(BUILD_DIR)/two_bath_reversible_exchange $(BUILD_DIR)/two_bath_perpendicular_exchange

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/two_bath_reversible_exchange: src/two_bath_reversible_exchange.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BUILD_DIR)/two_bath_perpendicular_exchange: src/two_bath_perpendicular_exchange.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

run: simulations
	$(BUILD_DIR)/two_bath_reversible_exchange
	$(BUILD_DIR)/two_bath_perpendicular_exchange

clean:
	rm -rf $(BUILD_DIR)

