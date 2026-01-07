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
      description = "Enable Git tools.";
    };
    useLatestGit = mkOption {
      type = types.bool;
      default = false;
      description = "Use latest Git from pkgs.";
    };
    userName = mkOption {
      type = types.nullOr types.str;
      default = "Adam Cooper";
      description = "Git user.name";
    };
    userEmail = mkOption {
      type = types.nullOr types.str;
      default = "adam@coopr.network";
      description = "Git user.email";
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
        description = "GPG key ID";
      };
    };

    githubCli = mkOption {
      type = types.bool;
      default = false;
      description = "Enable GitHub CLI";
    };
    installTools = mkOption {
      type = types.bool;
      default = false;
      description = "Install lazygit and tig";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = if cfg.useLatestGit then pkgs.git else pkgsStable.git;
      settings =
        (optionalAttrs (cfg.userName != null) { user.name = cfg.userName; })
        // {
          user.email = cfg.userEmail;
          color.ui = "auto";
          pull.rebase = false;
          push.default = "current";
          core.autocrlf = "input";
        }
        // (optionalAttrs cfg.gpgSign.enable {
          commit.gpgSign = true;
          tag.gpgSign = true;
          user.signingKey = cfg.gpgSign.key or "";
        });
    };

    home.packages = lib.concatLists (
      lib.optional cfg.githubCli [ pkgs.gh ]
      ++ lib.optional cfg.installTools [
        pkgs.lazygit
        pkgs.tig
      ]
    );
  };
}
