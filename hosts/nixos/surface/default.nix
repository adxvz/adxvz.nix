# hosts/nixos/surface/default.nix
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
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    # Mitigate screen flickering
    "i915.enable_psr=0"
  ];

  boot.initrd.kernelModules = [
    "surface_aggregator"
    "surface_aggregator_registry"
    "surface_aggregator_hub"
    "surface_hid_core"
    "surface_hid"
    "pinctrl-tigerlake"
    "intel_lpss"
    "intel_lpss_pci"
    "8250_dw"
    "surface_platform_profile"
    "surface_kbd"
    "surface_acpi_notify"
    "surface_battery"
    "surface_charger"
    "surface_aggregator_cdev"
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    alsa-lib
    libGL
    libglvnd
    libxkbcommon
    xorg.libX11
    xorg.libXi
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXxf86vm
    xorg.libXinerama
    wayland
  ];

  hardware.microsoft-surface.kernelVersion = "stable";

  # Disable the problematic suspend kernel module, it makes waking up
  # impossible after closing the cover.
  boot.blacklistedKernelModules = [ "surface_gpe" ];

  system.extraSystemBuilderCmds = ''
    ln -s ${self} $out/flake
    ln -s ${config.boot.kernelPackages.kernel.dev} $out/kernel-dev
  '';

  nix.registry = {
    nixpkgs.flake = inputs.nixos-unstable;
    current.to = {
      type = "path";
      path = "/run/booted-system/flake/";
    };
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
  };

  environment.variables = {
    # This ensures TouchOSC can find libavahi-compat-libdnssd.so at runtime
    LD_LIBRARY_PATH = "${pkgs.avahi-compat}/lib";
  };

  # Declare both to override base config for iso
  networking = {
    hostName = "surface";
    wireless.enable = true;
    networkmanager.enable = false;
  };

}
