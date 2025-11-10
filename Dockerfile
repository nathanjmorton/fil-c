FROM --platform=linux/amd64 ubuntu:22.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libc6-dev \
    linux-libc-dev \
    xz-utils \
    vim \
    nano \
    gdb \
    && rm -rf /var/lib/apt/lists/*

# Copy and extract the Fil-C tarball
COPY filc-0.674-linux-x86_64.tar.xz /tmp/
RUN cd /tmp && \
    tar -xf filc-0.674-linux-x86_64.tar.xz && \
    mkdir -p /usr/local/filc && \
    cp -r filc-0.674-linux-x86_64/build/ /usr/local/filc/ && \
    cp -r filc-0.674-linux-x86_64/pizfix/ /usr/local/filc/ && \
    rm -rf /tmp/filc-0.674-linux-x86_64* && \
    chmod +x /usr/local/filc/build/bin/*

# Add fil-c binaries to PATH
ENV PATH="/usr/local/filc/build/bin:$PATH"

# Set up environment for fil-c
ENV FILC_ROOT="/usr/local/filc"

# Create workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]