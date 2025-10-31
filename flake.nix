{
  description = "Embedded rust hello world with the micro:bit v2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      system = "x86_64-linux";
      overlays = [ rust-overlay.overlays.default ];
      pkgs = import nixpkgs { inherit system overlays; };

      # A Rust toolchain overridden to include the microcontroller target in nix so we don't have
      # to document some rustup commands. 
      rust = pkgs.rust-bin.stable.latest.default.override {
        targets = [ "thumbv7em-none-eabihf" ];
      };
    in
    {
      devShells.${system}.default =
        pkgs.mkShell {
          buildInputs = with pkgs; [
            rust
            cargo-binutils
            gcc-arm-embedded # Ships the arm-none-eabi-gdb binary
            probe-rs-tools
            minicom
            nixpkgs-fmt
          ];

          # Optional: helpful environment variables for Rust dev
          RUST_BACKTRACE = "1";
          RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;

          shellHook = ''
            echo "🦀 Evolved into a crab again... shit."
            rustc --version
          '';
        };

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
