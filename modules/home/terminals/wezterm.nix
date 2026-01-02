{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.wezterm;
  homeDir = config.home.homeDirectory;
  weztermConfigDir = "${homeDir}/.config/wezterm";
  weztermConfigFile = "${weztermConfigDir}/wezterm.lua";
in
{
  options.modules.wezterm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the WezTerm terminal emulator.";
    };

    shell = mkOption {
      type = types.str;
      default = "${pkgs.zsh}/bin/zsh";
      description = "Default shell to launch in WezTerm.";
    };

    managedConfig = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to use a WezTerm configuration managed by Home Manager.
        When disabled, WezTerm will use its built-in defaults or your own ~/.config/wezterm setup.
      '';
    };

    luaConfig = mkOption {
      type = types.lines;
      default = ''
        local wezterm = require 'wezterm'

        return {
          default_prog = { "${cfg.shell}" },
          color_scheme = "Gruvbox Dark",
          font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "FiraCode Nerd Font" }),
          font_size = 13.0,
          enable_tab_bar = false,
          window_padding = { left = 10, right = 10, top = 10, bottom = 10 },
          window_background_opacity = 0.95,
        }
      '';
      description = "The managed Lua configuration file for WezTerm.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.wezterm ];

    home.file = mkIf cfg.managedConfig {
      "${weztermConfigFile}".text = cfg.luaConfig;
    };

    # Create config directory if missing, but don’t overwrite custom configs
    home.activation.createWeztermConfigDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${weztermConfigDir}"
    '';
  };
}
