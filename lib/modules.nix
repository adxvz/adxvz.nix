{
  ...
}:

let
  # Shared modules (cross-platform)
  sharedModules = {
    nix = import ../modules/common/nix.nix;
    fonts = import ../modules/common/fonts.nix;
    hunspell = import ../modules/common/hunspell.nix;

  };
in
{
  darwinModules = {
    fonts = sharedModules.fonts;
    nix = sharedModules.nix;
    hunspell = sharedModules.hunspell;
    tuptime = import ../modules/darwin/tuptime.nix;
  };

  nixosModules = {
    fonts = sharedModules.fonts;
    nix = sharedModules.nix;
    hunspell = sharedModules.hunspell;
    # Surface Pro Hardware Modules
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
