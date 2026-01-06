{
  ...
}:

let
  # Shared modules (cross-platform)
  sharedModules = {
    fonts = import ../modules/common/fonts.nix;
    nix = import ../modules/common/nix.nix;
  };
in
{
  darwinModules = {
    fonts = sharedModules.fonts;
    nix = sharedModules.nix;
    hunspell = import ../modules/darwin/hunspell.nix;
    socket-vmnet = import ../modules/darwin/socket-vmnet.nix;
    tuptime = import ../modules/darwin/tuptime.nix;
  };

  nixosModules = {
    fonts = sharedModules.fonts;
    nix = sharedModules.nix;
    apfs = import ../modules/nixos/surface/apfs.nix;
    audio = import ../modules/nixos/surface/audio.nix;
    iptsd = import ../modules/nixos/surface/iptsd.nix;
    thermald = import ../modules/nixos/surface/thermald;
  };

  homeManagerModules = {
    # Shells
    fish = import ../modules/home/shells/fish.nix;
    nushell = import ../modules/home/shells/nushell.nix;
    zsh = import ../modules/home/shells/zsh.nix;

    # Terminals
    ghostty = import ../modules/home/terminals/ghostty.nix;
    wezterm = import ../modules/home/terminals/wezterm.nix;

    # CLI Tools
    scripts = import ../modules/home/cli/scripts.nix;
    ssh = import ../modules/home/cli/ssh.nix;
    gpg = import ../modules/home/cli/gpg.nix;
    git = import ../modules/home/cli/git.nix;
    jujutsu = import ../modules/home/cli/jujutsu.nix;

    # Window Managers
    #  niri = import ../modules/home/wm/niri.nix;

    # Applications
    emacs = import ../modules/home/apps/emacs;
  };
}
