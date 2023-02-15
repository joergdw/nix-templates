{
  description = "A very basic flake";

  outputs = { self }: {
    templates = {
      cfCnRustApp = {
        path = ./rust/cfCnRustApp;
        description = ''
          Template for buildin a cloud-native cloudfoundry-application
          with Rust, using cloud-native buildpackages.
        '';
        welcomeText = ''
          You have just created a template for a cloud-native rust-application running
          on cloudfoundry and build via a cloud-native buildpack.).

          To perform a minimal run, you need to configure appropriate values for
          DOCKER_REGISTRY and DOCKER_REPOSITORY in the Makefile and an appropriate
          route in the manifest. See comments in those files. You additionally
          need a working cloudfoundry-user and cloudfoundry-space.

          For more on cloud-native buildpacks, see: <https://buildpacks.io>
        '';
      };

      decSysConf = {
        path = ./decSysConf;
        description = "Flake realizing a declarative system configuration";
        welcomeText = ''
          You have just created a template for a declarative system-configuration
          with Nix.

          It contains an examle-package that you can install via `nix profile install '.#default'`.
          That package is a collection of the listed software. You can add or remove anything
          in the list and after an update, the installed software will be adapted. See the
          comments in the flake.nix

          There are some things you need to adapt following the comments in the flake.nix-file:
           + The parameter for `supported_system`.
           + Set `config.allowUnfree = true;` if you need to inlcude non-free software into your collections.
           + Check if the manpages are accessible from commandline.
           + Check if the shell-completion works. If not, follow the instructions in the comments of the flake.nix-file.
        '';
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
      };
    };
  };
}
