CXX ?= c++
CXXFLAGS ?= -O3 -std=c++17 -Wall -Wextra -pedantic

BIN_DIR := bin
RESULTS_DIR := results

DRIFT_SRC := src/nonlinear_random_walk_drift.cpp
UNIVERSALITY_SRC := src/universality_limit_check.cpp

DRIFT_BIN := $(BIN_DIR)/nonlinear_random_walk_drift
UNIVERSALITY_BIN := $(BIN_DIR)/universality_limit_check

.PHONY: all build run run-drift run-universality results clean

all: build

build: $(DRIFT_BIN) $(UNIVERSALITY_BIN)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(DRIFT_BIN): $(DRIFT_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(UNIVERSALITY_BIN): $(UNIVERSALITY_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

run: run-drift run-universality

run-drift: $(DRIFT_BIN)
	$(DRIFT_BIN)

run-universality: $(UNIVERSALITY_BIN)
	$(UNIVERSALITY_BIN)

results: $(DRIFT_BIN) $(UNIVERSALITY_BIN)
	mkdir -p $(RESULTS_DIR)
	$(DRIFT_BIN) > $(RESULTS_DIR)/nonlinear_random_walk_drift.txt
	$(UNIVERSALITY_BIN) > $(RESULTS_DIR)/universality_limit_check.csv

clean:
	rm -rf $(BIN_DIR)
