{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.niri;
  isNixOS = config ? system; # Detect if we're in NixOS or home-manager context
in
{
  options.modules.niri = {
    enable = mkEnableOption "Enable Niri window manager";

    # System-level options (only used in NixOS)
    system = {
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
        rofi = mkEnableOption "Install Rofi launcher" // {
          default = true;
        };
        waybar = mkEnableOption "Install Waybar status bar" // {
          default = true;
        };
        mako = mkEnableOption "Install Mako notification daemon" // {
          default = true;
        };
        swaylock = mkEnableOption "Install Swaylock screen locker" // {
          default = false;
        };
        fuzzel = mkEnableOption "Install Fuzzel launcher" // {
          default = true;
        };
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = "Additional packages to install with Niri";
      };
    };

    # User-level configuration options
    config = mkOption {
      type = types.either types.path types.str;
      default = ./config.kdl;
      description = "Path to Niri config.kdl file or inline configuration string";
    };
  };

  config = mkMerge [
    # NixOS system configuration
    (mkIf (isNixOS && cfg.enable) {
      # Enable required services for Wayland
      services.displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      # Make Niri available as a session
      services.displayManager.sessionPackages = [ cfg.system.package ];

      # Set default session if requested
      services.displayManager.defaultSession = mkIf cfg.system.defaultSession "niri";

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
          cfg.system.package

          # Core utilities
          wl-clipboard
          wlr-randr
          wayland-utils

          # Optional utilities based on config
        ]
        ++ optional cfg.system.utilities.rofi pkgs.rofi
        ++ optional cfg.system.utilities.waybar pkgs.waybar
        ++ optional cfg.system.utilities.mako pkgs.mako
        ++ optional cfg.system.utilities.swaylock pkgs.swaylock
        ++ optional cfg.system.utilities.fuzzel pkgs.fuzzel
        ++ cfg.system.extraPackages;

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
    })

    # Home-manager user configuration
    (mkIf (!isNixOS && cfg.enable) {
      xdg.configFile."niri/config.kdl" = {
        # If it's a path, use source; if it's a string, use text
        source = mkIf (builtins.isPath cfg.config) cfg.config;
        text = mkIf (builtins.isString cfg.config) cfg.config;
      };
    })
  ];
}
