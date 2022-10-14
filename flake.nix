{
  description = "A very basic flake";

  outputs = { self }: {
    templates = {
        default = self.templates.nixShell;

        nixShell = {
          path = ./nixShell;
          description = "Flake featuring a nix-shell environment used by direnv";
        };

        nixShellBC = {
          path = ./nixShellBC;
          description = "Flake featuring a nix-shell environment used by direnv in a backward-compatible way";
        };
    };
  };
}
