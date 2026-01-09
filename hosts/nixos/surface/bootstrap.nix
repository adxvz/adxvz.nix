{
  ...
}:

{
  imports = [
    ../../shared
    # ../../../modules/home/wm/gnome.nix
  ];

  modules = {
    fonts.enable = true;
    ghostty.enable = true;
    niri = {
      enable = true;
      rofi.enable = true;
      extraUtilities = {
        waybar = true;
        mako = true;
      };
      extraConfig = ''
        spawn-at-startup "ghostty"
      '';
    };
  };
  hardware.enableAllFirmware = true;
  hardware.apfs.autoMount = true;

  virtualisation.docker.enable = true;
  programs.zsh.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  system.stateVersion = "25.11";
}
