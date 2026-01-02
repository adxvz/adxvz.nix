{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [

  ];

  users.users.adxvz = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim
    xfce.mousepad
  ];

  services.xserver = {
    enable = true;
    xkb.layout = "gb";
  };

  programs.zsh.enable = true;

  system.stateVersion = "25.11";
}
