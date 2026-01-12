{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./build
    ../minimal.nix
    ./bootstrap.nix
  ];

  modules = {
    nix.enable = true;
    #cachix.enable = true;
    thermald.enable = true;
    iptsd.enable = true;
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
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.upower.enable = true;

  # Better tablet behavior
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    IdleAction = "ignore";
    KillUserProcesses = false;

  };

  environment.systemPackages = with pkgs; [
    surface-control
  ];
  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelParams = [
      # Mitigate screen flickering
      "i915.enable_psr=0"
    ];
    kernelPatches = [
      {
        name = "disable-rust";
        patch = null;
        extraConfig = ''
          RUST n
        '';
      }
    ];

    initrd.kernelModules = [
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

    # Disable the problematic suspend kernel module, it makes waking up
    # impossible after closing the cover.
    blacklistedKernelModules = [ "surface_gpe" ];
  };

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

  # Use wpa_supplicant in iso but not for full install
  networking.wireless.enable = lib.mkDefault true;
  #  networking.networkmanager.enable = lib.mkDefault false;

  hardware.microsoft-surface.kernelVersion = "stable";

  services.iptsd.enable = true;

  nixpkgs = {

    overlays = [
      (final: prev: {
        hidrd = prev.hidrd.overrideAttrs (old: {
          NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -Wno-error";
        });
      })
    ];
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";
  };
}
