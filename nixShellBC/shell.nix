{ pkgs ? import <nixpkgs> {} }:

# 🚸 For documentation on this, see:
# <https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell>
pkgs.mkShellNoCC {
  buildInputs = with pkgs; [
    # List your packages here:
    # […]
  ];

  # # Bash statements that get executed on startup:
  # shellHook = ''

  # '';
}
