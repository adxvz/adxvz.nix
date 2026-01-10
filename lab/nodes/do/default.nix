# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    nano
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZfTnBjCWqQb9sMDKV0/zokVbJlAoaJe/rX8yRBw3GN adam@coopr.network"

    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKHju1JLdRacpdkLvkjDthl3xWdWbUDsL828eGOu+L2Mz+agcz27rCrH49gYRhzt9sFDvpMvwoJcnZAZxTLDbQDrYeXf0NBLtW2Wici9x6FecwCJDUYDuCz0C+RHk1l1y6WE2Vc+xe+JoRQ7ZfeVjH32YRamwqRaPyvVGQ8jKvOlDgWa7FahuiV8OhQJB7Q9scuWAejZ01ERSAhEief+G9aQrQzA7YPcDyjVLsphS9uvH2XwKzjLa1VCL/fNjkVJZ8tTGwKJsNzE7b/d39xPRF9f0MjUVuUW+rzfXqHTnhc5ACFwESDMYhp1BM9vWwXoH1bd7oZGSdvZLSvhepRvX+wmhNZXngJq9dA5IWkYzjzy3L8Be9UUWGXjmt1HRLxkVShpo8Ur03KYR10iRS66HwEzO7uBbW5RfjtTCu2sLGxEj7GDqmd+adC/Qh6Iz9c2GlDQ0bShKu7X/5PIfEyhCJzUcxbKqp4ZA/FjMehtyPP1Hfx6lRi41TapxRfD7lABBPeaWRIjbwRVT90eObuDKVS4YgkgGp7vpVJJ+Ncq4wKXcTLrktomNyMVSZRVMm6vZqePJpjs1t2dJHHNJQUrNBrKQkd0b/moibUjKQQEa19XlZ5iKrTyUz9nPBmhF5kDZ2Ue2rMimmJnSBDaC4wl8dI4RVBn9TnIfFoZcduGiv4Q== adam@coopr.network"
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
