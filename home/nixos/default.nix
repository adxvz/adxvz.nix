{ lib, pkgs, ... }:

{

  home.packages = lib.mkIf pkgs.stdenv.isLinux [
    pkgs.xclip
  ];

  modules.niri = {
    enable = true;
    rofi.enable = true;
    extraUtilities = {
      waybar = true;
      mako = true;
    };
    extraConfig = ''
      spawn-at-startup "ghostty"
    '';
  };
}
