{
  description = "Embedded rust hello world with the micro:bit v2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system}.default = 
    pkgs.mkShell {
      buildInputs = with pkgs; [
        rustc
        cargo
        cargo-binutils
        # gdb-multiarch # TODO: this doesn't exist
        probe-rs-tools
        minicom
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
