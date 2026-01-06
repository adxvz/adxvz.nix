{
  config,
  lib,
  pkgs,
  pkgsStable,
  ...
}:

with lib;

let
  cfg = config.modules.git;
in
{
  options.modules.git = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Git configuration for the user.";
    };

    userName = mkOption {
      type = types.nullOr types.str;
      default = "Adam Cooper";
      description = "Git user.name configuration value.";
    };

    userEmail = mkOption {
      type = types.nullOr types.str;
      default = "adam@coopr.network";
      description = "Git user.email configuration value.";
    };

    extraConfig = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Additional git configuration options (key/value).";
      example = {
        core.editor = "nvim";
        init.defaultBranch = "main";
      };
    };

    useLatest = mkOption {
      type = types.bool;
      default = false;
      description = "If true, use the latest Git from pkgs instead of pkgsStable.";
    };

    gpgSign = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable GPG commit signing.";
      };

      key = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "GPG key ID to use for signing commits.";
      };
    };

    githubCli = mkOption {
      type = types.bool;
      default = false;
      description = "Enable GitHub CLI (gh) integration.";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = if cfg.useLatest then pkgs.git else pkgsStable.git;

      settings =
        (optionalAttrs (cfg.userName != null) {
          user.name = cfg.userName;
        })
        // (optionalAttrs (cfg.userEmail != null) {
          user.email = cfg.userEmail;
        })
        // {
          color.ui = "auto";
          pull.rebase = false;
          push.default = "current";
          core.autocrlf = "input";
        }
        // cfg.extraConfig
        // (optionalAttrs cfg.gpgSign.enable {
          commit.gpgSign = true;
          tag.gpgSign = true;
          user.signingKey = cfg.gpgSign.key or "";
        });
    };

    # Install GitHub CLI if enabled
    home.packages = mkIf cfg.githubCli [ pkgs.gh ];
  };
}
