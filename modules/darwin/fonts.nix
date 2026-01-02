{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.fonts;
in
{
  options.modules.fonts = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        maple-mono.NF
        #  dejavu_fonts
        fira-code
        #  hack-font
        #  inconsolata
        #  source-code-pro
        #  ubuntu_font_family
        #  nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        #  nerd-fonts.fantasque-sans-mono
        nerd-fonts.iosevka
        #  nerd-fonts.sauce-code-pro
        nerd-fonts.victor-mono
        nerd-fonts.symbols-only
        #  nerd-fonts._0xproto
        #  nerd-fonts.droid-sans-mono
        #  nerd-fonts.zed-mono
      ];
    };
  };
}
