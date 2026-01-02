{
  config,
  pkgs,
  inputs,
  self,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./bootstrap.nix
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-9
    self.nixosModules.surface
  ];

  # Secure Boot on Surface Firmware
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel (Surface kernels track linux-stable)
  hardware.microsoft-surface.kernelVersion = "stable";

  # Fix flickering + power regressions
  boot.kernelParams = [
    "i915.enable_psr=0"
    "mem_sleep_default=deep"
  ];

  # IPTS + Surface stack
  boot.initrd.kernelModules = [
    "intel_lpss"
    "intel_lpss_pci"
    "8250_dw"
  ];

  boot.kernelModules = [
    "surface_aggregator"
    "surface_aggregator_registry"
    "surface_aggregator_hub"
    "surface_hid_core"
    "surface_hid"
    "surface_kbd"
    "surface_battery"
    "surface_charger"
    "surface_platform_profile"
  ];

  boot.blacklistedKernelModules = [
    "surface_gpe"
  ];

  # IPTS daemon (touch + pen)
  #  services.iptsd = {
  #    enable = true;
  #    package = pkgs.iptsd;
  #  };

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  # Required for Wayland + proprietary apps
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    alsa-lib
    libGL
    libglvnd
    libxkbcommon
    wayland
    xorg.libX11
    xorg.libXi
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXxf86vm
    xorg.libXinerama
  ];

  # Networking
  networking = {
    hostName = "surface";
    #  networkmanager.enable = true;
    #  wireless.enable = false;
  };

  # Avahi (unchanged)
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # Registry pinning (excellent – keep this)
  nix.registry = {
    nixpkgs.flake = inputs.nixos-unstable;
    current.to = {
      type = "path";
      path = "/run/booted-system/flake/";
    };
  };

  system.extraSystemBuilderCmds = ''
    ln -s ${self} $out/flake
    ln -s ${config.boot.kernelPackages.kernel.dev} $out/kernel-dev
  '';
}
