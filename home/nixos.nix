{ lib, pkgs, ... }:

{

  home.packages = lib.mkIf pkgs.stdenv.isLinux [
    pkgs.xclip
  ];

  modules = {
    ghostty.enable = true;
  };

}
