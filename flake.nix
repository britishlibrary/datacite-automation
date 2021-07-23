{
  description = "A very basic flake";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.poetry2nix-src = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ poetry2nix-src.overlay ];
        };
      in {

        devShell = let
          pyEnv = pkgs.poetry2nix.mkPoetryEnv {
            projectDir = ./.;

            overrides = pkgs.poetry2nix.overrides.withDefaults (final: prev: {
              requests-unixsocket = prev.requests-unixsocket.overridePythonAttrs
                (old: {
                  nativeBuildInputs = (old.nativeBuildInputs or [ ])
                    ++ [ final.pbr ];
                });
            });
          };
        in pyEnv.env;
      });
}
