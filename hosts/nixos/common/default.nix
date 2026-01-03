{
  config,
  pkgs,
  lib,
  vars,
  versions,
  ...
}:

{
  imports = [ ];

  users.users.adxvz = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim
    xfce.mousepad
    git
    htop
  ];

  services.xserver.enable = true;
  services.xserver.layout = "gb";

  # Optional: Sway/Wayland for Surface touch/pen
  services.xserver.windowManager.sway.enable = true;

  programs.zsh.enable = true;

  system.stateVersion = "25.11";
}
