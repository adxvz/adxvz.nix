{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.fonts;

  # Standard fonts
  standardFonts = [
    pkgs.maple-mono.NF
    pkgs.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.victor-mono
    pkgs.nerd-fonts.symbols-only
  ];

  # Local fonts inside the flake
  customFontsDir = ./bible;

  # Collect *.ttf and *.otf files
  customFontFiles =
    let
      entries = builtins.readDir customFontsDir;
    in
    map (name: customFontsDir + "/${name}") (
      filter (name: hasSuffix ".ttf" name || hasSuffix ".otf" name) (attrNames entries)
    );

  # Turn each font into a proper Nix font package
  customFontPkgs = map (
    font:
    pkgs.stdenvNoCC.mkDerivation {
      pname = "custom-font-${baseNameOf font}";
      version = "1.0";
      src = font;
      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/share/fonts
        cp $src $out/share/fonts/
      '';
    }
  ) customFontFiles;

in
{
  options.modules.fonts.enable = mkEnableOption "system fonts";

  config = mkIf cfg.enable {
    # ONE option, works everywhere
    fonts.packages = standardFonts ++ customFontPkgs;
  };
}
