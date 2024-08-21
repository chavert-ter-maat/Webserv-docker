# Use a base image with gcc and other build essentials
FROM ubuntu:22.04

# Install necessary packages including g++, make, git, and build tools
RUN apt-get update && \
    apt-get install -y \
    g++-12 \
    make \
    curl \
    siege \
    libcurl4-openssl-dev \
    clang \
    git \
    build-essential \
    wget \
    libc6-dbg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Define the Valgrind version to install
ENV VALGRIND_VERSION=3.23.0

# Download, build, and install the latest Valgrind
RUN wget https://sourceware.org/pub/valgrind/valgrind-${VALGRIND_VERSION}.tar.bz2 && \
    tar xjf valgrind-${VALGRIND_VERSION}.tar.bz2 && \
    cd valgrind-${VALGRIND_VERSION} && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf valgrind-${VALGRIND_VERSION} valgrind-${VALGRIND_VERSION}.tar.bz2

# Set the working directory
WORKDIR /usr/src/app

# Clone the webserv repository from GitHub
RUN git clone https://github.com/chavert-ter-maat/Webserv.git .

# Copy the configuration file into the container
COPY ./basic_config.txt .

# Create necessary directories
RUN mkdir -p ./html/uploads

# Expose necessary ports
EXPOSE 8080-8093

