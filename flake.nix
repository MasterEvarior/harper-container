{
  description = "A very basic flake to show how nix and flakes can be used to package and distribute scripts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        treefmtEval = treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs = {
            # Code and Flake
            nixfmt.enable = true;
            mdformat.enable = true;
            yamllint.enable = true;
          };
        };
      in
      {
        packages = {
          default = pkgs.dockerTools.buildLayeredImage {
            name = "harper-container";
            config = {
              Entrypoint = [
                "${lib.getExe' pkgs.harper "harper-cli"}"
              ];
            };
          };

          image-tag = pkgs.runCommand "image-tag" { } ''
            ${lib.getExe pkgs.gnutar} -xf ${
              self.packages.${system}.default
            } --to-stdout manifest.json | ${lib.getExe pkgs.jq} -r '.[0].RepoTags[0]' >> $out
          '';

          version = pkgs.runCommand "version" { } ''
            ${lib.getExe pkgs.harper} --version | ${lib.getExe' pkgs.gawk "awk"} '{print $2}' >> $out
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            just
          ];

          shellHook = ''
            git config --local core.hooksPath .githooks/
          '';
        };

        formatter = treefmtEval.config.build.wrapper;

        checks = {
          lint = treefmtEval.config.build.check self;
        };
      }
    );
}
