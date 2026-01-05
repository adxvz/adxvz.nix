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
    mousepad
    git
    htop
  ];

  services.xserver.enable = true;
  services.xserver.layout = "gb";

  programs.zsh.enable = true;

}
