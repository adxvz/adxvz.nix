{
  ...
}:

{
  imports = [
    ./modules/gnome
    ../../common/pkgs.nix

  ];

  modules = {
    fonts.enable = true;

  };

  hardware.enableAllFirmware = true;
  hardware.apfs.autoMount = true;

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;

  programs.fish = {
    enable = true;
    useBabelfish = true;

  };

  system.stateVersion = "25.11";
}
