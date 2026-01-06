{ lib, pkgs, ... }:

{
  # Example: Linux-only HM settings
  home.packages = lib.mkIf pkgs.stdenv.isLinux [
    pkgs.xclip
  ];

}
