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
    # sops.enable = true;
    cachix.enable = true;
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

    masApps = {
      "Pixelmator Pro" = 1289583905;
      "Photomator" = 1444636541;
    };

    casks = [

      # Web Dev
      "ghostty"
      "transmit"
      "devtoys"
      "local"
      "canva"
      "zed"

      # Productivity
      "logos"
      "whatsapp"
      "microsoft-word"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-teams"
      "vivaldi"
      "google-chrome"

      # Mac Tools
      # "cleanmymac"
      "daisydisk"
      "logitech-options"
      "jordanbaird-ice@beta"
      "elgato-stream-deck"

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

}
