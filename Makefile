.DEFAULT_GOAL := help

.PHONY: help check scripts-check

help: ## Lista celów
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-16s %s\n", $$1, $$2}'

check: scripts-check ## Wszystko, co sprawdza CI (kolejne issues dopisują cele)

scripts-check: ## Testy skryptów z scripts/
	@bash scripts/tests/test-scripts.sh
