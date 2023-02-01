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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11"; # also possible: `"github:NixOS/nixpkgs/nixos-unstable";`
  };

  outputs = { self, nixpkgs }:
    let
      # Choose another system, in case this is not yours, e.g.: "x86_64-darwin" "aarch64-linux" "aarch64-darwin"
      # For a complete list of valid systems, see:
      # <https://github.com/numtide/flake-utils/blob/04c1b180862888302ddfb2e3ad9eaa63afc60cf8/default.nix>
      supported_system = "x86_64-linux";
    in {
      packages = {
        ${supported_system} =
          let
            pkgs = import nixpkgs { system = supported_system; };
          in {
            default = self.packages.${supported_system}.myStdPackages;

            myStdPackages =
              let
                pkgs = nixpkgs.legacyPackages.${supported_system}; # here we need just legacy packages
              in pkgs.buildEnv {
                name = "My standard packages";
                paths = with pkgs; [
                  bat
                  ripgrep
                  # […]
                ];

                extraOutputsToInstall = [ "man" "doc" ];
                # Regarding manpage-outputs:
                # To make use of the manpages, usually nothing is required but
                # including `source "${HOME}/.nix-profile/etc/profile.d/nix.sh"`
                # somewhere in the `"${HOME}/.profile"` or `"${HOME}/.bash_profile"` or `"${HOME}/.zshenv"`.
                #
                # You can verify the inclusion of the revelant directories via `manpath --debug`.
      
                # Regarding shell-completion:
                # With bash, everything should work out of the box.
                # With zsh, the following needs to be done somewhere in the `"${HOME}/.zshenv"`:
                # fpath=("${HOME}/.nix-profile/share/zsh/site-functions" ${fpath})`
                # See: <https://unix.stackexchange.com/questions/213593/how-to-add-a-dir-to-fpath>
              };

            ## You can define further collections as above and install them similarly:
            #myRustPackages = …
          };
      }; # packages
    }; # outputs
}
