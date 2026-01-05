{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../common
    ./modules/kappa
    ./modules/kappa/hardware/apfs.nix
    #  ./modules/shared/hideDesktopEntry.nix
    ./modules/shared/nh.nix
    #  ./modules/shared/git.nix
    ./modules/shared/disk.nix
    ./modules/shared/timeZone.nix
  ];

  hardware.enableAllFirmware = true;

  hardware.apfs.autoMount = true;

  environment.systemPackages = with pkgs; [
    yad
    vim
    xfce.mousepad
    alsa-utils

  ];

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
  };

  environment.variables = {
    # This ensures TouchOSC can find libavahi-compat-libdnssd.so at runtime
    LD_LIBRARY_PATH = "${pkgs.avahi-compat}/lib";
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
