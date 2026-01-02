{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.zsh;

in
{
  options.modules.zsh = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
    extraInit = mkOption {
      type = types.lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    home.shell.enableZshIntegration = true;

    programs.zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      defaultKeymap = "viins";
      enableCompletion = true;
      dotDir = "${config.xdg.configHome}/zsh";
      history = {
        append = true;
        save = 10000;
        size = 10000;
        share = true;
        ignoreDups = true;
        ignoreAllDups = true;
        saveNoDups = true;
        findNoDups = true;
        expireDuplicatesFirst = true;
        ignoreSpace = true;
        extended = true;
        path = "${config.xdg.configHome}/zsh/.zsh_history";
      };
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;
      zsh-abbr = {
        enable = true;
        abbreviations = import ./abbr.nix;
      };
      sessionVariables = {
      };
      setOptions = [
        "INC_APPEND_HISTORY"
        "HIST_REDUCE_BLANKS"
      ];
      antidote = {
        enable = true;
        plugins = [
          "getantidote/use-omz"
          "ohmyzsh/ohmyzsh path:plugins/sudo"
          "Aloxaf/fzf-tab"

        ];
      };
      envExtra = ''
        ZDOTDIR="$HOME/.config/zsh"
      '';
      initContent = ''
        # Nix
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi

        fastfetch

      '';
    };
  };
}
