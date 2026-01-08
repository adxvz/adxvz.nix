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
    enable = mkEnableOption "Enable Git configuration";

    shells = {
      bash = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Bash shell integration";
      };

      fish = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Fish shell integration";
      };

      zsh = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Zsh shell integration";
      };

      nushell = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Nushell shell integration";
      };
    };

    useLatestGit = mkOption {
      type = types.bool;
      default = false;
      description = "Use latest Git from pkgs instead of pkgsStable.";
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
      enable = mkEnableOption "Enable GPG commit signing";

      key = mkOption {
        type = types.nullOr types.str;
        default = "4C5D067A827FA98D60EA4742B9E578B362BE5DC6";
        description = "GPG key ID";
      };
    };

    githubCli = mkEnableOption "Enable GitHub CLI";

    gitTools = {
      enable = mkEnableOption "Install and configure additional Git TUI tools";

      lazygit = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable lazygit when gitTools is enabled";
        };

        settings = mkOption {
          type = types.attrs;
          default = { };
          description = ''
            Extra Home Manager configuration passed directly to
            programs.lazygit.settings.
            This is merged with sensible defaults.
          '';
        };
      };

      tig = mkOption {
        type = types.bool;
        default = true;
        description = "Enable tig when gitTools is enabled";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = if cfg.useLatestGit then pkgs.git else pkgsStable.git;

      settings =
        (optionalAttrs (cfg.userName != null) { user.name = cfg.userName; })
        // (optionalAttrs (cfg.userEmail != null) { user.email = cfg.userEmail; })
        // {
          color.ui = "auto";
          pull.rebase = false;
          push.default = "current";
          core.autocrlf = "input";
          init.defaultBranch = "main";
          log.decorate = "full";
          merge.conflictStyle = "diff3";
        }
        // (optionalAttrs cfg.gpgSign.enable {
          commit.gpgSign = true;
          tag.gpgSign = true;
          user.signingKey = cfg.gpgSign.key;
        });
    };

    home.packages = concatLists [
      (optional cfg.githubCli pkgs.gh)
      (optional (cfg.gitTools.enable && cfg.gitTools.tig) pkgs.tig)
      (optional (cfg.gitTools.enable && cfg.gitTools.lazygit.enable) pkgs.lazygit)
    ];

    programs.lazygit = mkIf (cfg.gitTools.enable && cfg.gitTools.lazygit.enable) {
      enable = true;

      enableBashIntegration = cfg.shells.bash;
      enableFishIntegration = cfg.shells.fish;
      enableZshIntegration = cfg.shells.zsh;
      enableNushellIntegration = cfg.shells.nushell;

      settings = mkForce (
        {
          disableStartupPopups = true;
          notARepository = "skip";
          promptToReturnFromSubprocess = false;
          update.method = "never";

          git = {
            commit.signOff = true;
            parseEmoji = true;
          };

          gui = {
            theme = {
              activeBorderColor = [
                "accent"
                "bold"
              ];
              inactiveBorderColor = [ "muted" ];
            };
            showListFooter = false;
            showRandomTip = false;
            showCommandLog = false;
            showBottomLine = false;
            nerdFontsVersion = "3";
          };
        }
        // cfg.gitTools.lazygit.settings
      );
    };
  };
}
