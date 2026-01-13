{ lib, pkgs, ... }:

{

  home = {

    packages = lib.mkIf pkgs.stdenv.isLinux [
      pkgs.xclip
    ];

    file = {
      ".config/ghostty/".source = ../modules/nixos/common/terminals/ghostty/config;
      # ".config/niri/".source = ../modules/nixos/common/wm/niri/config.kdl;
    };
  };
}
