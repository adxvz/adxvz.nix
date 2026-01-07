{
  ...
}:

{
  imports = [
    ../common
    ./gnome
    ../common/nh.nix
    ../common/disk.nix
    ../common/timeZone.nix
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
    interactiveShellInit = ''
      microfetch
    '';
  };

  system.stateVersion = "25.11";
}
