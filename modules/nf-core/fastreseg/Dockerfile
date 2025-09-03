# Stage 1: Build stage
FROM ubuntu:20.04 AS builder

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    dirmngr \
    gnupg \
    wget \
    build-essential \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install R
RUN apt-get update && apt-get install -y \
    r-base \
    r-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages including devtools and pkgdown
RUN R -e "install.packages(c('remotes', 'pkgdown'), repos='https://cloud.r-project.org/')"
RUN R -e "remotes::install_github('Nanostring-Biostats/FastReseg', ref='main')"

# Stage 2: Final image
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    r-base \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy only installed R packages from builder
COPY --from=builder /usr/local/lib/R /usr/local/lib/R

# Set working directory
WORKDIR /workspace