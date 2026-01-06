{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.thermald;
in
{
  options.modules.thermald = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable thermald with a custom thermal configuration.";
    };

    debug = mkOption {
      type = types.bool;
      default = true;
      description = "Enable thermald debug logging.";
    };

    configFile = mkOption {
      type = types.path;
      default = ./thermald/thermal-conf.xml;
      description = "Path to the thermald XML configuration file.";
    };
  };

  config = mkIf cfg.enable {
    services.thermald = {
      enable = true;
      debug = cfg.debug;
      configFile = cfg.configFile;
    };
  };
}
