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

        linuxSystem = {
          "x86_64-darwin" = "x86_64-linux";
          "aarch64-darwin" = "aarch64-linux";
        }.${system} or system;

        linuxPkgs = nixpkgs.legacyPackages.${linuxSystem};

        siteDir = builtins.getEnv "SITE_DIR";
        imageTag = builtins.getEnv "IMAGE_TAG";
        imageName = builtins.getEnv "IMAGE_NAME";
      in
      {
        packages.image =
          if siteDir == "" then
            throw "SITE_DIR must be an absolute path to the built site — run `task build-image` instead of calling nix directly"
          else
            linuxPkgs.callPackage ./nix/image.nix {
              site = builtins.path {
                name = "website-site";
                path = siteDir;
              };
              name = if imageName == "" then "website" else imageName;
              tag = if imageTag == "" then "dev" else imageTag;
            };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # Build tools
            typst
            hugo
            go-task
            go
            git
            dart-sass
            skopeo

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
