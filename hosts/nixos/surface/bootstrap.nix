{
  ...
}:

{
  imports = [
    ../../shared
    ../../../modules/nixos/common/wm/gnome.nix
  ];

  modules = {
    fonts.enable = true;
    ghostty.enable = true;
    #niri = {
    #  enable = true;
    #  defaultSession = true;
    #  utilities = {
    #    rofi = true;
    #    fuzzel = true;
    #    waybar = true;
    #    mako = true;
    #  };
    #};
  };
  hardware = {
    enableAllFirmware = true;
    apfs.autoMount = true;
    logitech.wireless.enable = true;
  };

  virtualisation.docker.enable = true;
  programs.zsh.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  system.stateVersion = "25.11";
}
