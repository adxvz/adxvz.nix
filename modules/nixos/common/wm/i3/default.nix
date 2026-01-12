{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.i3;
in
{
  options.modules.i3 = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable i3 window manager with sensible defaults";
    };

    customConfig = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to custom i3 configuration file";
      example = literalExpression "./i3-config";
    };

    enableAudio = mkOption {
      default = true;
      type = types.bool;
      description = "Enable audio support via PipeWire";
    };

    displayManager = mkOption {
      default = "lightdm";
      type = types.enum [ "lightdm" "gdm" "sddm" ];
      description = "Which display manager to use";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional packages to install with i3";
      example = literalExpression "[ pkgs.rofi pkgs.polybar ]";
    };
  };

  config = mkIf cfg.enable {
    # Enable X11
    services.xserver = {
      enable = true;

      # Display manager configuration
      displayManager = {
        lightdm.enable = cfg.displayManager == "lightdm";
        gdm.enable = cfg.displayManager == "gdm";
        sddm.enable = cfg.displayManager == "sddm";
        defaultSession = "none+i3";
      };

      # Window manager
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu        # Application launcher
          i3status     # Status bar
          i3lock       # Screen locker
          i3blocks     # Alternative status bar
        ] ++ cfg.extraPackages;
      };
    };

    # Audio configuration
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = cfg.enableAudio;
    services.pipewire = mkIf cfg.enableAudio {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Apply custom i3 configuration if provided
    environment.etc."i3/config" = mkIf (cfg.customConfig != null) {
      source = cfg.customConfig;
    };

    # Set XDG_CONFIG_HOME for i3 to find custom config
    environment.sessionVariables = mkIf (cfg.customConfig != null) {
      I3_CONFIG_PATH = "/etc/i3/config";
    };
  };
}
