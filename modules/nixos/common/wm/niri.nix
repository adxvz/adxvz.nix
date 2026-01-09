{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.niri;
in
{
  options.modules.niri = {
    enable = mkEnableOption "Enable Niri window manager";

    package = mkOption {
      type = types.package;
      default = pkgs.niri;
      description = "Niri package to use";
    };

    defaultSession = mkOption {
      type = types.bool;
      default = true;
      description = "Set Niri as the default session";
    };

    utilities = {
      rofi = mkEnableOption "Enable Rofi launcher" // {
        default = true;
      };
      waybar = mkEnableOption "Enable Waybar status bar" // {
        default = true;
      };
      mako = mkEnableOption "Enable Mako notification daemon" // {
        default = true;
      };
      swaylock = mkEnableOption "Enable Swaylock screen locker" // {
        default = false;
      };
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional packages to install with Niri";
    };
  };

  config = mkIf cfg.enable {
    # Enable required services for Wayland
    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # Make Niri available as a session
    services.displayManager.sessionPackages = [ cfg.package ];

    # Set default session if requested
    services.displayManager.defaultSession = mkIf cfg.defaultSession "niri";

    # Enable XDG portal for screen sharing, file picking, etc.
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config.common.default = "*";
    };

    # Required for Wayland compositors
    security.polkit.enable = true;

    # System packages needed for Niri
    environment.systemPackages =
      with pkgs;
      [
        cfg.package

        # Core utilities
        wl-clipboard
        wlr-randr
        wayland-utils

        # Optional utilities based on config
      ]
      ++ optional cfg.utilities.rofi pkgs.rofi
      ++ optional cfg.utilities.waybar pkgs.waybar
      ++ optional cfg.utilities.mako pkgs.mako
      ++ optional cfg.utilities.swaylock pkgs.swaylock
      ++ cfg.extraPackages;

    # Enable required system services
    programs.dconf.enable = true;
    services.dbus.enable = true;

    # Pipewire for audio (if not already enabled)
    services.pipewire = {
      enable = mkDefault true;
      alsa.enable = mkDefault true;
      pulse.enable = mkDefault true;
    };

    # Fonts
    fonts.enableDefaultPackages = true;

    # XDG user directories
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Hint for Electron apps to use Wayland
      MOZ_ENABLE_WAYLAND = "1"; # Firefox Wayland
    };
  };
}
