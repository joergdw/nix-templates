{
  description = "A very basic flake";

  outputs = { self }: {
    templates = {
      cfRustApp = {
        path = ./rust/cfCnRustApp;
        description = ''
          Template for buildin a cloud-native cloudfoundry-application
          with Rust, using cloud-native buildpackages.
        ''
      };

      decSysConf = {
        path = ./decSysConf;
        description = "Flake realizing a declarative system configuration";
      };

      default = self.templates.nixShell;

      nixShell = {
        path = ./nixShell;
        description = "Flake featuring a nix-shell environment used by direnv";
      };

      nixShellBC = {
        path = ./nixShellBC;
        description = "Flake featuring a nix-shell environment used by direnv in a backward-compatible way";
      };

      tailoredTeXLive = {
        path = ./tailoredTeXLive;
        description = "Flake for generating documents with LaTeX featuring a tailored TeXLive-Distribution";
      }
    };
  };
}
