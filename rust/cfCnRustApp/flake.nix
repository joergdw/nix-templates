# This flake has been created from the template `github:joergdw/nix-templates#cfCnRustApp`.
{
  description = ''
    Flake-Template for creating a cloudfoundry-app in Rust, featuring a nix
    development environment and using cloud-native buildpacks.
  '';

  inputs = {
    # 🚧 To-do: Choose your nix-branch from <https://github.com/NixOS/nixpkgs/branches>,
    # preferably stable ones!
    nixpkgsRepo.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgsRepo }:
    let
      nixpkgsLib = nixpkgsRepo.lib;

      # Instead of using the subsequent list of self-defined helpers, one could use
      # `flake-utils` as additional argument (this does not require an additional input)
      # which provides similar helpers and keeps them up-to-date.
      # For more information on this, see: <https://github.com/numtide/flake-utils>

      # List all systems that should be supported. See
      # <https://github.com/numtide/flake-utils/blob/04c1b180862888302ddfb2e3ad9eaa63afc60cf8/default.nix>
      # for a complete list.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgsLib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgsRepo { inherit system; });
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in {
          default = self.packages.${system}.rustApp;

          rustApp = pkgs.rustPlatform.buildRustPackage {
            pname = "cf-rust-app"; # 🚧 To-do: Modify this to you need.
            version = # 🚧 To-do: Change version-numbering, if needed.
              let
                lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
              in builtins.substring 0 8 lastModifiedDate;
            src = ./.;

            # ⚠️ A Cargo.lock-file or similar is needed for reproducability.
            cargoLock.lockFile = ./Cargo.lock;
            ## If you don't want to use a Cargo.lock-file: 🚧 To-do: Insert correct hash.
            ## Build the package once and then take the actual hash from the failed build.
            # cargoSha256 = pkgs.lib.fakeSha256;
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              bash
              buildpack
              cargo
              cloudfoundry-cli
              docker-client
              gnumake
              rust-analyzer
              rustc
              rustfmt
              zstd
            ];
          };
        });
    };
}