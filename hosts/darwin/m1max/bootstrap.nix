{
  config,
  pkgs,
  vars,
  ...
}:
{

  modules = {
    fonts.enable = true;
    hunspell.enable = true;
    tuptime.enable = true;
    nix.enable = true;
  };

  users.users.${vars.primaryUser} = {
    home = "/Users/${vars.primaryUser}";
    name = "${vars.primaryUser}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  system.primaryUser = vars.primaryUser;

  documentation.info.enable = false;

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      cleanup = "zap";
      autoUpdate = true;
    };

    # Declared by nix-homebrew
    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [
      "trellis-cli"
      "composer"
      "ansible"
    ];

    # To look up the App ID for the application you want installed, run the following command in a teminal:
    #  nix run nixpkgs#mas search "<Application Name>"
    #BUG: MacOS Tahoe Developer Beta has currently broken mas cli function. https://github.com/mas-cli/mas/issues/1029

    # masApps = {
    #   "Pixelmator Pro" = 1289583905;
    #   "Photomator" = 1444636541;
    # };

    casks = [
      "ghostty"
      "transmit"
      "devtoys"
      "logos"
      "microsoft-word"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-teams"
      "whatsapp"
      "local"
      "vivaldi"
      "canva"
      "zed"

      # Mac Tools
      # "cleanmymac"
      "daisydisk"
      "jordanbaird-ice@beta"

      # Music Apps
      "ableton-live-suite"
      "arturia-software-center"
      "ilok-license-manager"
      "ik-product-manager"
      "midi-monitor"
      "native-access"
      "softube-central"
      "spitfire-audio"
      "x32-edit"
      "touchosc-bridge"
      "touchosc"
      "protokol"
      "valhalla-space-modulator"
      "valhalla-freq-echo"
      "valhalla-supermassive"
      "audacity"
    ];

    caskArgs.no_quarantine = true;

  };

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
    gh
    gnupg
    lsd
    fzf
    mpv
    nushell
    pinentry_mac
    cachix
    shottr
    raycast
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
