{
  config,
  lib,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.modules.fonts;

  # Correct cross-platform font directory
  fontTargetDir =
    if pkgs.stdenv.isDarwin then
      "${config.home.homeDirectory}/Library/Fonts"
    else
      "${config.home.homeDirectory}/.local/share/fonts";

  # Fonts to install
  fontList = [
    pkgs.maple-mono.NF
    pkgs.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.victor-mono
    pkgs.nerd-fonts.symbols-only
  ];

in
{
  options.modules.fonts = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable installation of additional fonts.";
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = fontList;

      # Ensure fonts go to the proper directory
      enableFontDirs = true;
      fontDirs = [ fontTargetDir ];
    };
  };
}
