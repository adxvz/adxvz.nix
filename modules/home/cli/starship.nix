{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.starship;
in
{
  options.modules.starship = {
    enable = mkEnableOption "Enable starship shell history";

    daemon = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the starship background daemon";
    };

    shells = {
      bash = mkEnableOption "Enable Bash integration" // {
        default = true;
      };
      fish = mkEnableOption "Enable Fish integration" // {
        default = true;
      };
      zsh = mkEnableOption "Enable Zsh integration" // {
        default = true;
      };
      nushell = mkEnableOption "Enable Nushell integration" // {
        default = true;
      };
    };

    server = {
      enable = mkEnableOption "Use a custom/self-hosted starship server";

      address = mkOption {
        type = types.str;
        default = "";
        example = "https://starship.example.com";
        description = "Custom starship server address";
      };
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra starship settings merged into programs.starship.settings";
    };
  };

  config = mkIf cfg.enable {
    # Ensure starship is installed by the module itself
    home.packages = [
      pkgs.starship
    ];

    programs.starship = {
      enable = true;

      enableBashIntegration = cfg.shells.bash;
      enableFishIntegration = cfg.shells.fish;
      enableZshIntegration = cfg.shells.zsh;
      enableNushellIntegration = cfg.shells.nushell;

      settings = {
        add_newline = true;
        continuation_prompt = "[▸▹ ](dimmed white)";
        format = lib.concatStrings [
          "$directory"
          "$fill"
          "$line_break"
          "$character"
        ];
        right_format = lib.concatStrings [
          "$kubernetes"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_status"
          "$git_metrics"
          "$docker_context"
          "$package"
          "$golang"
          "$helm"
          "$lua"
          "$perl"
          "$php"
          "$python"
          "$terraform"
          "$vagrant"
          "$memory_usage"
          "$aws"
          "$gcloud"
          "$azure"
          "$custom"
          "$status"
          "$os"
          "$battery"
          "$time"
          "$cmd_duration"
        ];
        palette = "nord";
        character = {
          success_symbol = "[󰘍](bold green)";
          error_symbol = "[✗](bold red)";
        };
        username = {
          style_user = "white bold";
          style_root = "red bold";
          format = "user: [$user]($style) ";
          disabled = true;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          detect_env_vars = [
            "!TMUX"
            "SSH_CONNECTION"
          ];
          disabled = true;
        };

        directory = {
          style = "bold fg:teal";
          format = "[$path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          truncate_to_repo = false;
        };

        git_branch = {
          style = "fg:green";
          symbol = " ";
          format = "[on](white) [$symbol$branch ]($style)";
        };

        git_status = {
          style = "fg:yellow";
          format = "([$all_status$ahead_behind]($style) )";
        };

        fill = {
          symbol = " ";
        };

        python = {
          style = "teal";
          symbol = " ";
          format = "[$symbol$(pyenv_prefix)($version )((\\($virtualenv\\) )]($style)";
          pyenv_version_name = true;
          pyenv_prefix = "";
        };

        lua = {
          symbol = " ";
        };

        nodejs = {
          style = "blue";
          symbol = " ";
        };

        golang = {
          style = "blue";
          symbol = " ";
        };

        haskell = {
          style = "blue";
          symbol = " ";
        };

        rust = {
          style = "orange";
          symbol = " ";
        };

        ruby = {
          style = "blue";
          symbol = " ";
        };

        package = {
          symbol = "󰏗 ";
        };

        aws = {
          symbol = " ";
          style = "yellow";
          format = "[$symbol($profile )((\\[$duration\\] )]($style)";
        };

        nix_shell = {
          disabled = false;
          impure_msg = "[impure shell](bold red)";
          pure_msg = "[pure shell](bold green)";
          unknown_msg = "[unknown shell](bold yellow)";
          format = "via [☃️ $state( \\($name\\))](bold blue) ";
        };

        shell = {
          bash_indicator = "󱆃";
          zsh_indicator = "";
          fish_indicator = "󰈺 ";
          nu_indicator = "";
          powershell_indicator = "_";
          unknown_indicator = "󰆆 ";
          style = "cyan bold";
          disabled = false;
        };

        docker_context = {
          symbol = " ";
          style = "fg:#06969A";
          format = "[$symbol]($style) $path";
          detect_files = [
            "docker-compose.yml"
            "docker-compose.yaml"
            "Dockerfile"
          ];
          detect_extensions = [ "Dockerfile" ];
        };

        jobs = {
          symbol = " ";
          style = "red";
          number_threshold = 1;
          format = "[$symbol]($style)";
        };

        cmd_duration = {
          min_time = 500;
          style = "fg:white";
          format = "[$duration]($style)";
        };

        palettes = {
          nord = {
            dark_blue = "#5E81AC";
            blue = "#81A1C1";
            teal = "#88C0D0";
            red = "#BF616A";
            orange = "#D08770";
            green = "#A3BE8C";
            yellow = "#EBCB8B";
            purple = "#B48EAD";
            gray = "#434C5E";
            black = "#2E3440";
            white = "#D8DEE9";
          };

          onedark = {
            dark_blue = "#61afef";
            blue = "#56b6c2";
            red = "#e06c75";
            green = "#98c379";
            purple = "#c678dd";
            cyan = "#56b6c2";
            orange = "#be5046";
            yellow = "#e5c07b";
            gray = "#828997";
            white = "#abb2bf";
            black = "#2c323c";
          };
        };
      }
      // cfg.settings
      // optionalAttrs cfg.server.enable {
        sync_address = cfg.server.address;
      };
    };
  };
}
