{
  description = "Flake for ??? featuring a nix-shell";

  inputs = {
    # Choose your nix-branch from <https://github.com/NixOS/nixpkgs/branches>,
    # preferably stable ones!
    nixpkgsRepo.url = github:NixOS/nixpkgs/nixos-unstable;
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
      devShells = forAllSystems (system:
        let
          nixpkgs = nixpkgsFor.${system};
        in {
          default = nixpkgs.mkShell {
            buildInputs = with nixpkgs; [
              # List your packages here:
              # […]
            ];
          };
        });
    };
}