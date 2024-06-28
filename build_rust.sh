#!/bin/bash

# Set paths
FLUTTER_PROJECT_PATH="$(pwd)"
# shellcheck disable=SC2034
RUST_PROJECT_PATH="$FLUTTER_PROJECT_PATH/rustlib"
LINUX_LIBS_PATH="$FLUTTER_PROJECT_PATH/linux"
WINDOWS_LIBS_PATH="$FLUTTER_PROJECT_PATH/windows"
MACOS_LIBS_PATH="$FLUTTER_PROJECT_PATH/macos"

# Build Rust project for the appropriate target
echo "Building Rust project..."
cd "$RUST_PROJECT_PATH" || exit

# Build for all supported targets
cargo build --release --target x86_64-unknown-linux-gnu
cargo build --release --target x86_64-pc-windows-gnu
cargo build --release --target x86_64-apple-darwin

# Create directories if not exist
mkdir -p "$LINUX_LIBS_PATH"/lib
mkdir -p "$WINDOWS_LIBS_PATH"/lib
mkdir -p "$MACOS_LIBS_PATH"/lib

# Copy the compiled libraries to the appropriate directories
echo "Copying Rust library to Flutter project..."
cp target/x86_64-unknown-linux-gnu/release/librustlib.so "$LINUX_LIBS_PATH"/lib
cp target/x86_64-pc-windows-gnu/release/rustlib.dll "$WINDOWS_LIBS_PATH"/lib
cp target/x86_64-apple-darwin/release/librustlib.dylib "$MACOS_LIBS_PATH"/lib

echo "Build and copy completed."
