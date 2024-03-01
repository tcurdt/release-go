{
  description = "release-go";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/23.11";

    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, gomod2nix, gitignore }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ system, pkgs, ... }:
        let
          buildGoApplication = gomod2nix.legacyPackages.${system}.buildGoApplication;
        in
        rec {
          default = release-go;

          release-go = buildGoApplication {
            name = "release-go";
            src = gitignore.lib.gitignoreSource ./.;
            go = pkgs.go_1_21;
            pwd = ./.; # Must be added due to bug https://github.com/nix-community/gomod2nix/issues/120
            # subPackages = [ "cmd/templ" ];
            CGO_ENABLED = 0;
            flags = [
              "-trimpath"
            ];
            ldflags = [
              "-s"
              "-w"
              "-extldflags -static"
            ];
          };

        });

      # `nix develop` provides a shell containing development tools.
      devShell = forAllSystems ({ system, pkgs }:
        pkgs.mkShell {
          buildInputs = with pkgs; [
            (golangci-lint.override { buildGoModule = buildGo121Module; })
            go_1_21
            # gopls
            # goreleaser
            # gomod2nix.legacyPackages.${system}.gomod2nix
          ];
        });

      overlays.default = final: prev: {
        release-go = self.packages.${final.stdenv.system}.release-go;
      };
    };
}
