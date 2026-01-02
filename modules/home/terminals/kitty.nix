{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.kitty;
  homeDir = config.home.homeDirectory;
  kittyConfigDir = "${homeDir}/.config/kitty";
  kittyConfigFile = "${kittyConfigDir}/kitty.conf";
in
{
  options.modules.kitty = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Kitty terminal emulator.";
    };

    shell = mkOption {
      type = types.str;
      default = "${pkgs.zsh}/bin/zsh";
      description = "Default shell to launch in Kitty.";
    };

    managedConfig = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to use a Kitty configuration managed by Home Manager.
        When disabled, Kitty will use its built-in defaults or your own ~/.config/kitty setup.
      '';
    };

    kittyConfig = mkOption {
      type = types.lines;
      default = ''
        # Kitty default managed configuration
        shell ${cfg.shell}
        font_family JetBrainsMono Nerd Font
        font_size 13.0
        window_padding_width 10
        window_padding_height 10
        background_opacity 0.95
        hide_tab_bar yes
        color_scheme Gruvbox Dark
      '';
      description = "Managed Kitty configuration content.";
    };

  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.kitty ];

    # Create Kitty config directory if missing
    home.activation.createKittyConfigDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${kittyConfigDir}"
    '';

    # Write managed Kitty config if enabled
    home.file = mkIf cfg.managedConfig {
      "${kittyConfigFile}".text = cfg.kittyConfig;
    };

  };
}
