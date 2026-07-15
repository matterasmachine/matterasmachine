CXX ?= c++
CXXFLAGS ?= -O3 -std=c++17 -Wall -Wextra -pedantic

BIN_DIR := bin
RESULTS_DIR := results

MULTINOMIAL_SRC := src/taxicab_velocity_entropy_cost.cpp
MULTINOMIAL_BIN := $(BIN_DIR)/taxicab_velocity_entropy_cost

.PHONY: all build run results clean

all: build

build: $(MULTINOMIAL_BIN)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(MULTINOMIAL_BIN): $(MULTINOMIAL_SRC) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

run: $(MULTINOMIAL_BIN)
	$(MULTINOMIAL_BIN)

results: $(MULTINOMIAL_BIN)
	mkdir -p $(RESULTS_DIR)
	$(MULTINOMIAL_BIN) > $(RESULTS_DIR)/taxicab_velocity_entropy_cost.csv

clean:
	rm -rf $(BIN_DIR)
