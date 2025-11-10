#!/bin/bash

# Fil-C Docker Development Helper Script
# This script provides convenient commands for developing with Fil-C using Docker

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo -e "${BLUE}Fil-C Docker Development Environment${NC}"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  build                Build the Fil-C Docker image"
    echo "  shell                Start an interactive shell in the container"
    echo "  compile <file.c>     Compile a C file"
    echo "  run <executable>     Run a compiled program"
    echo "  compile-and-run <file.c> Compile and run a C program"
    echo "  clean                Stop and remove containers"
    echo ""
    echo "Examples:"
    echo "  $0 build"
    echo "  $0 compile hello.c"
    echo "  $0 compile-and-run examples/hello.c"
    echo "  $0 shell"
    echo ""
    echo "Note: All compilation happens inside a Docker container using Fil-C,"
    echo "      but source files and executables are stored on your host system."
}

build_image() {
    echo -e "${YELLOW}Building Fil-C Docker image...${NC}"
    echo -e "${BLUE}This will download Ubuntu, install dependencies, and extract Fil-C${NC}"
    docker-compose build
    echo -e "${GREEN}✓ Fil-C Docker image built successfully${NC}"
}

start_shell() {
    echo -e "${YELLOW}Starting interactive Fil-C development shell...${NC}"
    echo -e "${BLUE}You can use 'clang' and 'clang++' commands directly${NC}"
    docker-compose run --rm filc bash
}

compile_file() {
    local source_file="$1"
    local output_file="${source_file%.*}"
    
    if [[ ! -f "$source_file" ]]; then
        echo -e "${RED}Error: File '$source_file' not found${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Compiling $source_file with Fil-C...${NC}"
    docker-compose run --rm filc clang -o "$output_file" "$source_file" -O2 -g
    echo -e "${GREEN}✓ Compiled successfully: $output_file${NC}"
}

run_program() {
    local executable="$1"
    
    if [[ ! -f "$executable" ]]; then
        echo -e "${RED}Error: Executable '$executable' not found${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Running $executable...${NC}"
    echo -e "${BLUE}--- Output ---${NC}"
    docker-compose run --rm filc "./$executable"
}

compile_and_run() {
    local source_file="$1"
    local output_file="${source_file%.*}"
    
    compile_file "$source_file"
    run_program "$output_file"
}

clean_containers() {
    echo -e "${YELLOW}Cleaning up Docker containers and networks...${NC}"
    docker-compose down
    echo -e "${GREEN}✓ Cleanup complete${NC}"
}

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi

# Main script logic
case "${1:-}" in
    "build")
        build_image
        ;;
    "shell")
        start_shell
        ;;
    "compile")
        if [[ -z "${2:-}" ]]; then
            echo -e "${RED}Error: Please specify a C file to compile${NC}"
            print_usage
            exit 1
        fi
        compile_file "$2"
        ;;
    "run")
        if [[ -z "${2:-}" ]]; then
            echo -e "${RED}Error: Please specify an executable to run${NC}"
            print_usage
            exit 1
        fi
        run_program "$2"
        ;;
    "compile-and-run")
        if [[ -z "${2:-}" ]]; then
            echo -e "${RED}Error: Please specify a C file to compile and run${NC}"
            print_usage
            exit 1
        fi
        compile_and_run "$2"
        ;;
    "clean")
        clean_containers
        ;;
    "help"|"-h"|"--help")
        print_usage
        ;;
    "")
        print_usage
        ;;
    *)
        echo -e "${RED}Error: Unknown command '$1'${NC}"
        print_usage
        exit 1
        ;;
esac