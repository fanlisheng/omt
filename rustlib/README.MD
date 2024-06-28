https://juejin.cn/post/7176077601746714681

cargo new --lib rustlib

cargo install flutter_rust_bridge_codegen


flutter_rust_bridge_codegen generate --rust-input crate::api --rust-root rustlib --dart-output lib/rust/rustlib.dart


######
cargo install cbindgen

cargo build

cbindgen --crate rustlib --lang c --output headers/rustlib.h

flutter_rust_bridge_codegen

dart run ffigen

brew tap messense/macos-cross-toolchains
brew install x86_64-unknown-linux-gnu

rustup target add x86_64-unknown-linux-gnu

brew install mingw-w64
rustup target add x86_64-pc-windows-gnu

rustup target add x86_64-pc-windows-gnu
rustup target add x86_64-apple-darwin

[package]
name = "rustlib"
version = "0.1.0"
edition = "2021"

[dependencies]

[lib]
name = "rustlib"
crate-type = ["cdylib"]


