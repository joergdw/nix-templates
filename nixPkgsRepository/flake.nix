{
  description = "Personal collection of Nix-packages for open-source-software";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, flake-utils, nixpkgs-stable, nixpkgs-unstable }@inputs:
    let supportedSystems = flake-utils.lib.defaultSystems;
    in flake-utils.lib.eachSystem supportedSystems (system:
      let
        nixpkgs = import nixpkgs-stable {
          inherit system;
        };
        lib = nixpkgs.lib;
        callPkgContext = nixpkgs // {
          inherit supportedSystems system;
        };
        callPackage = lib.customisation.callPackageWith callPkgContext;
      in {
        packages = {
          hello = callPackage ./packages/hello {};
        };
      });
}
