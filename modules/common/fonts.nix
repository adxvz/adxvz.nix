{
  config,
  lib,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.modules.fonts;

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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable installation of additional fonts.";
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = fontList;
  };
}
