# Installation Guide

## Quick Setup for GitHub Users

### Step 1: Clone this repository
```bash
git clone <your-repo-url>
cd <repo-name>
```

### Step 2: Download Fil-C
Download the Fil-C Linux x86_64 tarball and place it in the root directory:

**Option A: Direct download**
```bash
# Download the latest Fil-C release (replace URL with actual release)
curl -L -o filc-0.674-linux-x86_64.tar.xz \
  https://github.com/pizlonator/fil-c/releases/download/v0.674/filc-0.674-linux-x86_64.tar.xz
```

**Option B: Manual download**
1. Go to https://github.com/pizlonator/fil-c/releases
2. Download `filc-0.674-linux-x86_64.tar.xz`
3. Place it in the root directory of this project

### Step 3: Build and test
```bash
# Build the Docker image
./filc.sh build

# Test with the hello world example
./filc.sh compile-and-run examples/hello.c
```

### Step 4: Start developing
```bash
# Create your C files in src/ or anywhere in the project
echo '#include <stdio.h>
int main() {
    printf("My first Fil-C program!\\n");
    return 0;
}' > src/myprogram.c

# Compile and run
./filc.sh compile-and-run src/myprogram.c
```

## Directory Structure After Installation

```
your-repo/
├── src/                          # Your C source files
├── examples/                     # Example programs
├── filc-0.674-linux-x86_64.tar.xz  # Fil-C tarball (you download this)
├── Dockerfile                    # Docker configuration
├── docker-compose.yml           # Docker Compose config
├── filc.sh                      # Helper script
├── README.md                    # Main documentation
└── INSTALL.md                   # This file
```

## Prerequisites

- Docker Desktop installed and running
- `curl` (for downloading Fil-C) or web browser
- Git (for cloning the repository)

## Troubleshooting Installation

**Missing tarball**: Make sure `filc-0.674-linux-x86_64.tar.xz` is in the root directory

**Docker permission errors (Linux)**:
```bash
sudo usermod -aG docker $USER
# Logout and login again
```

**Build fails**: Ensure you have enough disk space (image is ~2GB)

**Network issues**: Check if Docker can access the internet for downloading Ubuntu base image

## Next Steps

- Read the main [README.md](README.md) for detailed usage
- Check out the examples in `examples/`
- Start writing your memory-safe C programs in `src/`