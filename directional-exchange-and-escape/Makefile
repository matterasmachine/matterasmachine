CXX ?= c++
CXXFLAGS ?= -O3 -std=c++17 -Wall -Wextra -pedantic
BUILD_DIR := build
PROGRAMS := test_geometric_robustness test_escape_history_weight predict_endpoints_from_escape_chain test_vue_large_n_perpendicular

.PHONY: all paper simulations run clean

all: paper simulations

paper:
	typst compile paper/geometric-endpoint-statistics.typ paper/geometric-endpoint-statistics.pdf

simulations: $(PROGRAMS:%=$(BUILD_DIR)/%)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%: src/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

run: simulations
	@for program in $(PROGRAMS); do \
		echo "=== $$program ==="; \
		$(BUILD_DIR)/$$program; \
	done

clean:
	rm -rf $(BUILD_DIR)

