{
   description = "Flake for ??? featuring a nix-shell";

   inputs = {
      flake-utils.url = "github:numtide/flake-utils";

      # Choose your nix-branch from <https://github.com/NixOS/nixpkgs/branches>,
      # preferably stable ones!
      nixpkgs-repo.url = github:NixOS/nixpkgs/nixos-unstable;
   };

   outputs = { self, flake-utils, nixpkgs-repo }: flake-utils.lib.eachDefaultSystem (system:
        let
           nixpkgsLib = nixpkgs-repo.lib;
           nixpkgs = nixpkgs-repo.legacyPackages.${system};
        in {
           devShells = {
              # 🚸 For documentation on this, see:
              # <https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell>
              default = nixpkgs.mkShellNoCC {
                 packages = with nixpkgs; [
                    # List your packages here:
                    # […]
                 ];

                 # # Bash statements that get executed on startup:
                 # shellHook = ''

                 # '';
              };
           };
        });
}
