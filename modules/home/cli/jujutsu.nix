{
  config,
  lib,
  pkgs,
  pkgsStable,
  ...
}:

with lib;

let
  cfg = config.modules.jujutsu;
in
{
  options.modules.jujutsu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Jujutsu (JJ) configuration for the user.";
    };

    useLatest = mkOption {
      type = types.bool;
      default = false;
      description = "If true, use the latest Jujutsu from pkgs instead of pkgsStable.";
    };

    extraConfig = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Additional Jujutsu configuration options (key/value).";
    };

    userName = mkOption {
      type = types.nullOr types.str;
      default = "Adam Cooper";
      description = "Jujutsu user.name configuration value.";
    };

    userEmail = mkOption {
      type = types.nullOr types.str;
      default = "adam@coopr.network";
      description = "Jujutsu user.email configuration value.";
    };
  };

  config = mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;
      package = if cfg.useLatest then pkgs.jujutsu else pkgsStable.jujutsu;

      settings =
        (optionalAttrs (cfg.userName != null) { "user.name" = cfg.userName; })
        // (optionalAttrs (cfg.userEmail != null) { "user.email" = cfg.userEmail; })
        // cfg.extraConfig;
    };
  };
}
