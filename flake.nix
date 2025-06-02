{
  description = "Development environment with Node.js and npm";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      # bugged, fix in prog: https://github.com/Davidyz/VectorCode/issues/73
      perSystem =
        { pkgs, system, ... }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs
              nodePackages.npm
              vectorcode
              python312Packages.chromadb
            ];
          };
        };
    };
}
