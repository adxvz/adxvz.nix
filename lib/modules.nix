{
  ...
}:

let
  # Shared modules (cross-platform)
  sharedModules = {
    nix = import ../modules/common/nix.nix;
    fonts = import ../modules/common/fonts;
    hunspell = import ../modules/common/hunspell.nix;
    #  cachix = import ../modules/common/cachix.nix;

  };
in
{
  darwinModules = {
    fonts = sharedModules.fonts;
    nix = sharedModules.nix;
    hunspell = sharedModules.hunspell;
    #    cachix = sharedModules.cachix;

  };

  nixosModules = {
    fonts = sharedModules.fonts;
    nix = sharedModules.nix;
    hunspell = sharedModules.hunspell;
    #  cachix = sharedModules.cachix;

    ghostty = import ../modules/nixos/common/terminals/ghostty;

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

    # CLI Tools
    atuin = import ../modules/home/cli/atuin.nix;
    bat = import ../modules/home/cli/bat.nix;
    fastfetch = import ../modules/home/cli/fastfetch.nix;
    starship = import ../modules/home/cli/starship.nix;
    yazi = import ../modules/home/cli/yazi.nix;

    ssh = import ../modules/home/cli/ssh.nix;
    gpg = import ../modules/home/cli/gpg.nix;
    git = import ../modules/home/cli/git.nix;
    jujutsu = import ../modules/home/cli/jujutsu.nix;

    # Window Managers
    #  niri = import ../modules/home/wm/niri.nix;

    # Editors
    emacs = import ../modules/home/editors/emacs;
    # nvf = import ../modules/home/editors/nvf.nix;

  };
}
