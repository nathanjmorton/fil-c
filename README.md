# Fil-C Docker Development Environment

A containerized development environment for [Fil-C](https://fil-c.org/), the memory-safe C compiler. This setup allows you to develop with Fil-C on any platform that supports Docker.

## What is Fil-C?

Fil-C is a memory-safe C compiler that prevents memory safety bugs like buffer overflows, use-after-free, and memory leaks while maintaining C compatibility.

## Quick Start

### Prerequisites
- Docker and Docker Compose installed on your system
- The Fil-C tarball (`filc-0.674-linux-x86_64.tar.xz`) should be in this directory

### 1. Build the Docker image
```bash
make build
```

### 2. Compile and run the hello world example
```bash
make compile-and-run examples/hello.c
```

## Available Commands

Use these Makefile commands for development:

- **`make build`** - Build the Fil-C Docker image
- **`make shell`** - Start an interactive shell in the container
- **`make compile <file.c>`** - Compile a C file with Fil-C
- **`make run <executable>`** - Run a compiled program
- **`make compile-and-run <file.c>`** - Compile and run in one step
- **`make clean`** - Stop and remove Docker containers

## Development Workflow

1. **Write your C code** in the `src/` directory (or anywhere in the project)
2. **Compile with Fil-C** using `make compile yourfile.c`
3. **Run your program** using `make run yourfile`
4. **Or do both** with `make compile-and-run yourfile.c`

## Project Structure

```
├── src/                          # Your source files go here
├── examples/                     # Example programs
│   └── hello.c                   # Hello world example
├── filc-0.674-linux-x86_64.tar.xz  # Fil-C compiler tarball
├── Dockerfile                    # Docker image definition
├── docker-compose.yml           # Docker Compose configuration
├── filc.sh                      # Development helper script
└── README.md                    # This file
```

## Examples

### Basic compilation
```bash
# Create a simple C program
echo '#include <stdio.h>
int main() { printf("Hello World!\\n"); return 0; }' > hello.c

# Compile and run
make compile-and-run hello.c
```

### Interactive development
```bash
# Start an interactive shell
make shell

# Inside the container, you can use clang directly:
clang -o myprogram myprogram.c -O2 -g
./myprogram
```

### Advanced compilation options
```bash
# Use docker-compose directly for custom flags
docker-compose run --rm filc clang -o debug hello.c -g -O0 -fsanitize=address
```

## How It Works

- **Docker Build**: The Dockerfile extracts the Fil-C tarball and sets up the environment
- **Bind Mounting**: Your project directory is mounted into the container at `/workspace`
- **Cross-Platform**: Works on macOS, Linux, and Windows with Docker
- **Memory Safety**: All compilation uses Fil-C's memory-safe runtime

## Notes

- Compiled executables are Linux binaries that run inside Docker containers
- The setup uses `linux/amd64` platform for compatibility with Fil-C's x86_64 binaries
- Source files and executables persist on your host system thanks to bind mounting
- The first build will take a few minutes to download Ubuntu and extract Fil-C

## Troubleshooting

**Build fails**: Ensure the `filc-0.674-linux-x86_64.tar.xz` file is in the root directory

**Docker not found**: Install Docker Desktop and ensure it's running

**Permission errors**: On Linux, you may need to add your user to the docker group:
```bash
sudo usermod -aG docker $USER
# Then logout and login again
```

**Platform warnings**: ARM64 vs x86_64 warnings are expected on Apple Silicon Macs and can be ignored

## Getting Fil-C

Download the latest Fil-C release from:
- GitHub: https://github.com/pizlonator/fil-c/releases
- Website: https://fil-c.org/

Make sure to download the Linux x86_64 version and place the tarball in this directory.

## Contributing

This is a community-maintained Docker environment for Fil-C development. Feel free to submit issues and pull requests!