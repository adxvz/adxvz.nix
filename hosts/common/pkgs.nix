{ pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  commonPackages = with pkgs; [
    asciinema_3
    croc
    ttyd
    fd
    ripgrep
    doctl
    exercism
    gnupg
    lsd
    fzf
    mpv
    cachix
    tree
    tree-sitter
    tlrc
    p7zip
    ffmpeg
    ffmpegthumbnailer
    zoxide
    wget
    nodejs_24
    cargo
    go
    gzip
  ];

  darwinPackages = with pkgs; [
    pinentry_mac
    shottr
    raycast
    obsidian
    itsycal
    zoom-us
  ];

  nixosPackages = with pkgs; [
    nixos-rebuild
    nushell
    yad
    vim
    mousepad
    alsa-utils
    gawk
    wget
    iftop
    lm_sensors
    screen
    iptsd
    file
    binutils
    coreutils
    ghostty
    vlc
    thunderbird
    vivaldi
    foliate
  ];
in
{
  environment.systemPackages =
    commonPackages ++ lib.optionals isDarwin darwinPackages ++ lib.optionals isLinux nixosPackages;
}
