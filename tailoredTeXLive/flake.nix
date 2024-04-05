{
  description = "Flake for ??? featuring a nix-shell with a tailored TeXLive-LaTeX-Distribution";

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
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in {
          # This flake contains this tailored TeX Live package. For more
          # information about it, see:
          # + <https://flyx.org/nix-flakes-latex/>
          # + <https://nixos.wiki/wiki/TexLive>
          # + <https://nixos.wiki/wiki/Tex>
          #
          # NixOS contains as well a nearly complete TeXLive-distribution. For this,
          # you need to install instead: `texlive.combined.scheme-full`
          # Its size is roughly 5GiB.
          tailoredTeXLive = pkgs.texlive.combine {
            inherit (pkgs.texlive)
            scheme-minimal # see: <https://nixos.wiki/wiki/TexLive#Combine_Sets>
            latex-bin # includes lualatex

            # # Everything what follows here, may be found on:
            # # <https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/typesetting/tex/texlive/pkgs.nix>

            # # Common collections:
            collection-fontsrecommended
            collection-mathscience
            collection-latex
            # collection-latexextra
            collection-latexrecommended
            collection-luatex
            collection-langenglish
            # collection-langfrench
            # collection-langgerman
            # collection-langspanish

            # # List additional packages here:
            # algorithm2e
            # […]
            # amsmath
            # […]
            # biber
            # […]

            latexmk # see: <https://ctan.org/pkg/latexmk>
            # […]
            ;
          };
        }); # end packages

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = [
              self.packages.${system}.tailoredTeXLive
              pkgs.texlab # LSP-Implementation
            ];
          };
      }); # end devShells
    }; # end outputs
}