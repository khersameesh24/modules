# Use official Rust image as base for the build environment
FROM rust:1.85

# Set the working directory inside the container
WORKDIR /app

# clone the repo
RUN git clone https://github.com/dcjones/proseg.git && \
    cd proseg/ && \
    cargo install proseg

ENTRYPOINT ["/bin/bash"]

