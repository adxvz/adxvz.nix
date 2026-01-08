{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.ghostty;
in
{
  ##############################################################################
  # OPTIONS
  ##############################################################################
  options.modules.ghostty = {
    enable = mkEnableOption "Enable Ghostty terminal server";

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

  };

  ##############################################################################
  # CONFIG
  ##############################################################################
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ghostty ];

    programs.ghostty = {
      enable = true;
      installBatSyntax = true;
      installVimSyntax = true;
      enableBashIntegration = cfg.shells.bash;
      enableFishIntegration = cfg.shells.fish;
      enableZshIntegration = cfg.shells.zsh;
      settings = {
        background-opacity = 0.95;
        background-blur-radius = 20;
        macos-non-native-fullscreen = true;
        macos-option-as-alt = "left";
        mouse-hide-while-typing = true;
        font-family = "Maple Mono NF";
        font-style-bold = "Medium";
        font-style-bold-italic = "Medium Italic";
        font-size = 13.4;
        font-thicken = true;
        grapheme-width-method = "unicode";
        adjust-cell-width = "-5%";
        selection-invert-fg-bg = true;
        cursor-style = "bar";
        cursor-style-blink = true;
        window-padding-x = 20;
        window-padding-y = "2,10";
        window-save-state = "always";
        shell-integration = "detect";
        scrollback-limit = 1000000;
        alpha-blending = "native";
        keybind = [
          "ctrl+n=new_window"
          "ctrl+h=goto_split:left"
          "ctrl+j=goto_split:bottom"
          "ctrl+k=goto_split:top"
          "ctrl+l=goto_split:right"
          "ctrl+z>h=new_split:left"
          "ctrl+z>j=new_split:down"
          "ctrl+z>k=new_split:up"
          "ctrl+z>l=new_split:right"
          "ctrl+z>f=toggle_split_zoom"
          "ctrl+z>n=next_tab"
          "ctrl+z>p=previous_tab"
          "ctrl+z>x=close_surface"
          "super+r=reload_config"
        ];
      };
    };
  };
}
