{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../common
  ];

  environment.systemPackages = with pkgs; [
    vim
    zed-editor
    git
    neovim
    htop
    wayland-protocols
    wl-clipboard
    sway
    grim
    slurp
    ghostty
  ];
}
