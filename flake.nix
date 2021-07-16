{
  description = "A very basic flake";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {

        # TODO: use poetry2nix to link this with pyproject.toml
        devShell = pkgs.mkShell {
          buildInputs = with pkgs;
            with pkgs.python38Packages; [
              python
              poetry
              pyzmq
              jupyterlab
              numpy
              scipy
              pandas
              XlsxWriter
              httpx
              python-dotenv
              faker
            ];
        };

      });
}
