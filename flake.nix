{
  description = "Karl Kaiser personal website + resume dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # Build tools
            typst
            hugo
            go-task

            # Fonts (typst picks these up via TYPST_FONT_PATHS below)
            lato
            font-awesome

            # PDF tooling — pdftoppm / pdftotext / pdffonts / pdfinfo
            poppler-utils
          ];

          # Point typst at the font packages directly so it works regardless of
          # whether fontconfig is set up on the host.
          shellHook = ''
            export TYPST_FONT_PATHS="${pkgs.lato}/share/fonts:${pkgs.font-awesome}/share/fonts"
          '';
        };
      });
}
