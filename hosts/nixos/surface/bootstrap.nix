{
  ...
}:

{
  imports = [
    ../common
    ./gnome
    ./modules/shared/nh.nix
    ./modules/shared/disk.nix
    ./modules/shared/timeZone.nix
  ];

  modules = {
    audio = {
      enable = true;
      disablePulseAudio = true;
      rtkitEnable = true;
      pipewireEnable = true;
      pipewireAlsaEnable = true;
      pipewireAlsa32BitSupport = true;
      pipewirePulseEnable = true;
    };
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
