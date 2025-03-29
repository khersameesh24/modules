# Use official Rust image as base for the build environment
FROM rust:1.85

# Set the working directory inside the container
WORKDIR /app

# clone the repo
RUN git clone https://github.com/dcjones/proseg.git && \
    cd proseg/ && \
    cargo install proseg


# Create a non-root user for security
RUN useradd --create-home psuser
USER psuser


# specify the entrypoint
ENTRYPOINT ["/bin/bash"]
