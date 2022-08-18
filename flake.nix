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
        python = pkgs.python39.withPackages (py:
          with py; [
            jupyterlab

            numpy
            scipy
            pandas
            XlsxWriter

            httpx
            aiohttp
            faker
            python-dotenv
            altair
            munch

            (pkgs.poetry2nix.mkPoetryEditablePackage {
              python = pkgs.python39;
              projectDir = ./lib/dcrest;
              editablePackageSources = { dcrest = ./lib/dcrest; };
            })
          ]);

      in { devShell = with pkgs; mkShell { buildInputs = [ python ]; }; });
}
