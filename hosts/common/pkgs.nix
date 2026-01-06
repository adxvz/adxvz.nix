{
  pkgs,
  ...
}:

{

  environment.shells = with pkgs; [
    bashInteractive
    zsh
    fish
  ];

  environment.systemPackages = with pkgs; [
    asciinema_3
    atuin
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
    nushell
    pinentry_mac
    cachix
    shottr
    raycast
    obsidian
    itsycal
    tree
    tree-sitter
    tlrc
    p7zip
    ffmpeg
    ffmpegthumbnailer
    zoom-us
    zoxide
    nixos-rebuild
    wget
    nodejs_24
    cargo
    go
    gzip
  ];

}
