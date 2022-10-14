# Filename: ~/.config/nixpkgs/flake.nix
#
# This is a declarative Nix-Configuration in the spirit of
# https://nixos.org/manual/nixpkgs/stable/#sec-declarative-package-management
# and adapted to nix-flakes.
#
# For this to work with the new nix-cli, you need to activate flakes, see:
# https://nixos.wiki/wiki/Flakes#Enable_flakes
#
# Subsequently, it is assumed that you use the new nix-cli. For using the old one
# instead, please load this flake into your package-overrides, see:
#  + https://nixos.org/manual/nixpkgs/stable/#sec-declarative-package-management
#  + https://discourse.nixos.org/t/nix-profile-in-combination-with-declarative-package-management/21228/6
#  + https://discourse.nixos.org/t/nix-profile-in-combination-with-declarative-package-management/21228/7
#
# Installed packages can be listet with `nix profile list`.
# To install a certain package defined in the flake, change to the directory the flake resides in and use:
# `nix profile install '.#<packageIdentifier>'`.
# To update all packages, use from within the same folder `nix flake update && nix profile upgrade '.*'`.
# Don't forget to perform sometimes a garbage-collection when your system is in a fine state.
{
  description = "A declarative system installation using nix-flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05"; # also possible: `"github:NixOS/nixpkgs/nixos-unstable";`
  };

  outputs = { self, nixpkgs }:
    let
      # Choose another system, in case this is not yours, e.g.: "x86_64-darwin" "aarch64-linux" "aarch64-darwin"
      supported_systems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supported_systems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in {
          default = self.packages.${system}.myStdPackages;

          myStdPackages =
            let
              pkgs = nixpkgs.legacyPackages.${system}; # here we need just legacy packages
            in pkgs.buildEnv {
              name = "My standard packages";
              paths = with pkgs; [
                bat
                ripgrep
                # […]
              ];

               extraOutputsToInstall = [ "man" "doc" ];
            };

          ## You can define further collections as above and install them similarly:
          #myRustPackages = …
        }); # packages
    }; # outputs
}