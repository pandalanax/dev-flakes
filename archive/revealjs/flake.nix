{
  description = "Node.js API for Chrome";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    revealjs = {
      url = "github:hakimel/reveal.js";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    revealjs,
  }: let
    pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    revealjs = pkgs.fetchFromGitHub {
      owner = "hakimel";
      repo = "reveal.js";
      rev = "2927be34d83bc0f0552867092272390ae951a715";
      hash = "sha256-dZDRmOAlCAKRrQtlf5p5DqMK+LciMIBVkSugcRvObUY=";
    };
  in {
    # leaving this here as how to build a npm package

    # defaultPackage.aarch64-darwin = self.packages.aarch64-darwin.revealjs;

    devShells.aarch64-darwin.default = let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in
      pkgs.mkShell {
        packages = with pkgs; [nodejs openssl];
        buildInputs = [revealjs];

        shellHook = ''
          echo $buildInputs
          # TODO: how to add the repo writeable inside folder but only once for setup..
          # ln -s $buildInputs reveal.js

          # echo 'now installing npm packages..'
          # npm install
        '';
      };
  };
}
