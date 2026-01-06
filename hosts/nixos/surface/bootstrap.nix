{
  ...
}:

{
  imports = [
    ../common
    ./modules/kappa/software/gnome
    # ./modules/kappa/hardware/apfs.nix
    #  ./modules/shared/hideDesktopEntry.nix
    ./modules/shared/nh.nix
    #  ./modules/shared/git.nix
    ./modules/shared/disk.nix
    ./modules/shared/timeZone.nix
  ];

  hardware.enableAllFirmware = true;
  hardware.apfs.autoMount = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish.enable = true;
  };

  environment.variables = {
  };

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;

  programs.fish = {
    enable = true;
    useBabelfish = true;
    interactiveShellInit = ''
      microfetch
    '';
  };

  # Declare both to override base config for iso
  # networking = {
  #   hostName = "surface";
  #   wireless.enable = false;
  #   networkmanager.enable = true;
  # };

  system.stateVersion = "25.11";
}
