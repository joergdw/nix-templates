{
  description = "Flake for ??? featuring a nix-shell";

  inputs = {
    # Choose your nix-branch from <https://github.com/NixOS/nixpkgs/branches>,
    # preferably stable ones!
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  };

  outputs = { self, nixpkgs }:
    let
      # Instead of using the subsequent list of self-defined helpers, one could use
      # `flake-utils` as additional argument (this does not require an additional input)
      # which provides similar helpers and keeps them up-to-date.
      # For more information on this, see: <https://github.com/numtide/flake-utils>

      # List all systems that should be supported. See
      # <https://github.com/numtide/flake-utils/blob/04c1b180862888302ddfb2e3ad9eaa63afc60cf8/default.nix>
      # for a complete list.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in {
          default = import ./shell.nix { inherit pkgs; };
        });
    };
}