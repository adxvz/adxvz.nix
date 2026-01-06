{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.iptsd;
in
{
  options.modules.iptsd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable iptsd (Intel Precise Touch & Stylus Daemon).";
    };

    disableOnPalm = mkOption {
      type = types.bool;
      default = true;
      description = "Disable touchscreen input when palm is detected.";
    };

    disableOnStylus = mkOption {
      type = types.bool;
      default = true;
      description = "Disable touchscreen input when stylus is detected.";
    };
  };

  config = mkIf cfg.enable {
    services.iptsd = {
      enable = true;
      config = {
        Touchscreen.DisableOnPalm = cfg.disableOnPalm;
        Touchscreen.DisableOnStylus = cfg.disableOnStylus;
      };
    };

    environment.systemPackages = with pkgs; [
      iptsd
    ];
  };
}
