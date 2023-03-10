# This is a declarative Nix-Configuration created from the template `github:joergdw/nix-templates#decSysConf`.
#
# For this to work with the new nix-cli, you need to activate flakes, see:
# https://nixos.wiki/wiki/Flakes#Enable_flakes
#
# Installed packages can be listet with `nix profile list`.
# To install a certain package defined in the flake, change to the directory the flake resides in and use:
# `nix profile install '.#<packageIdentifier>'`.
# To update all packages, use from within the same folder `nix flake update && nix profile upgrade '.*'`.
# Don't forget to perform sometimes a garbage-collection when your system is in a fine state.
{
  description = "A declarative system installation using nix-flakes;";

  inputs = {
    # TODO: Choose your nix-branch from <https://github.com/NixOS/nixpkgs/branches>,
    # preferably stable ones!
    nixpkgsRepo.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgsRepo }:
    let
      # TODO: Choose another system, in case this is not yours.
      # You should be able to get it via executing `nix eval --impure --raw --expr 'builtins.currentSystem'`
      # on a terminal.
      # Other common values are "x86_64-darwin", "aarch64-linux" and "aarch64-darwin".
      # For a complete list of valid systems, see:
      # <https://github.com/numtide/flake-utils/blob/04c1b180862888302ddfb2e3ad9eaa63afc60cf8/default.nix>
      supported_system = "x86_64-linux";

      nixpkgs = import nixpkgsRepo {
        system = supported_system;
        # config.allowUnfree = true; # TODO: Set this, if you want to include non-free software.
      };
    in {
      packages = {
        ${supported_system} = {
          default = self.packages.${supported_system}.myStdPackages;

          myStdPackages = nixpkgs.buildEnv {
              name = "My standard packages";
              paths = with nixpkgs; [
                bat
                ripgrep
                # […]
              ];

              # TODO: Choose which extra outputs you want to have
              extraOutputsToInstall = [ "man" "doc" ];
              #
              # TODO: Install this package via `nix profile install '.#myStdPackages'`.
              #
              # TODO: Check if manpages are available if chosen as extra output:
              # To make use of the manpages, usually nothing is required but
              # including `source "${HOME}/.nix-profile/etc/profile.d/nix.sh"`
              # somewhere in the `"${HOME}/.profile"` or `"${HOME}/.bash_profile"` or `"${HOME}/.zshenv"`.
              #
              # You can verify the inclusion of the revelant directories via `manpath --debug`.
              #
              # TODO: Make shell-completion functional:
              # With bash, everything should work out of the box.
              # With zsh, the following needs to be done somewhere in the `"${HOME}/.zshenv"`:
              # `fpath=("${HOME}/.nix-profile/share/zsh/site-functions" ${fpath})`
              # See: <https://unix.stackexchange.com/questions/213593/how-to-add-a-dir-to-fpath>
            };

          ## You can define further collections as above and install them similarly:
          #myRustPackages = …
        }; # system
      }; # packages

      # TODO for the author of this template: Integrate: https://www.tweag.io/blog/2020-07-31-nixos-flakes
    }; # outputs
}
