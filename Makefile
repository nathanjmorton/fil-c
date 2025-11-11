.PHONY: help build shell compile run compile-and-run clean

# Colors for output
YELLOW := \033[1;33m
GREEN := \033[0;32m
BLUE := \033[0;34m
RED := \033[0;31m
NC := \033[0m

# Default target
help:
	@echo "$(BLUE)Fil-C Docker Development Environment$(NC)"
	@echo ""
	@echo "Usage: make [COMMAND] [OPTIONS]"
	@echo ""
	@echo "Commands:"
	@echo "  make build                      Build the Fil-C Docker image"
	@echo "  make shell                      Start an interactive shell in the container"
	@echo "  make compile <file.c>           Compile a C file"
	@echo "  make run <executable>           Run a compiled program"
	@echo "  make compile-and-run <file.c>   Compile and run a C program"
	@echo "  make clean                      Stop and remove containers"
	@echo ""
	@echo "Examples:"
	@echo "  make build"
	@echo "  make compile hello.c"
	@echo "  make run hello"
	@echo "  make compile-and-run examples/hello.c"
	@echo "  make shell"
	@echo ""
	@echo "Note: All compilation happens inside a Docker container using Fil-C,"
	@echo "      but source files and executables are stored on your host system."

# Build the Docker image
build:
	@echo "$(YELLOW)Building Fil-C Docker image...$(NC)"
	@echo "$(BLUE)This will download Ubuntu, install dependencies, and extract Fil-C$(NC)"
	@docker-compose build
	@echo "$(GREEN)✓ Fil-C Docker image built successfully$(NC)"

# Start an interactive shell
shell:
	@echo "$(YELLOW)Starting interactive Fil-C development shell...$(NC)"
	@echo "$(BLUE)You can use 'clang' and 'clang++' commands directly$(NC)"
	@docker-compose run --rm filc bash

# Compile a C file
compile:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "$(RED)Error: Please specify a C file to compile$(NC)"; \
		echo "Example: make compile hello.c"; \
		exit 1; \
	fi
	@FILE="$(filter-out $@,$(MAKECMDGOALS))"; \
	if [ ! -f "$$FILE" ]; then \
		echo "$(RED)Error: File '$$FILE' not found$(NC)"; \
		exit 1; \
	fi; \
	echo "$(YELLOW)Compiling $$FILE with Fil-C...$(NC)"; \
	docker-compose run --rm filc clang -o "$$(basename $$FILE .c)" "$$FILE" -O2 -g; \
	echo "$(GREEN)✓ Compiled successfully: $$(basename $$FILE .c)$(NC)"

# Run a compiled program
run:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "$(RED)Error: Please specify an executable to run$(NC)"; \
		echo "Example: make run hello"; \
		exit 1; \
	fi
	@EXEC="$(filter-out $@,$(MAKECMDGOALS))"; \
	if [ ! -f "$$EXEC" ]; then \
		echo "$(RED)Error: Executable '$$EXEC' not found$(NC)"; \
		exit 1; \
	fi; \
	echo "$(YELLOW)Running $$EXEC...$(NC)"; \
	echo "$(BLUE)--- Output ---$(NC)"; \
	docker-compose run --rm filc "./$$EXEC"

# Prevent make from treating the filename as a target
%:
	@:

# Compile and run a C program
compile-and-run:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "$(RED)Error: Please specify a C file to compile and run$(NC)"; \
		echo "Example: make compile-and-run hello.c"; \
		exit 1; \
	fi
	@FILE="$(filter-out $@,$(MAKECMDGOALS))"; \
	if [ ! -f "$$FILE" ]; then \
		echo "$(RED)Error: File '$$FILE' not found$(NC)"; \
		exit 1; \
	fi; \
	echo "$(YELLOW)Compiling $$FILE with Fil-C...$(NC)"; \
	docker-compose run --rm filc clang -o "$$(basename $$FILE .c)" "$$FILE" -O2 -g; \
	echo "$(GREEN)✓ Compiled successfully: $$(basename $$FILE .c)$(NC)"; \
	echo "$(YELLOW)Running $$(basename $$FILE .c)...$(NC)"; \
	echo "$(BLUE)--- Output ---$(NC)"; \
	docker-compose run --rm filc "./$(shell basename $(filter-out $@,$(MAKECMDGOALS)) .c)"

# Clean up Docker containers and networks
clean:
	@echo "$(YELLOW)Cleaning up Docker containers and networks...$(NC)"
	@docker-compose down
	@echo "$(GREEN)✓ Cleanup complete$(NC)"
