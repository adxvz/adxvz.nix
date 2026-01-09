{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.niri;
in
{
  options.modules.niri = {
    enable = mkEnableOption "Enable Niri window manager";

    package = mkOption {
      type = types.package;
      default = pkgs.niri;
      description = "Niri package to use";
    };

    rofi = {
      enable = mkEnableOption "Enable Rofi launcher integration" // {
        default = true;
      };
      package = mkOption {
        type = types.package;
        default = pkgs.rofi-wayland;
        description = "Rofi package to use";
      };
      theme = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "~/.config/rofi/theme.rasi";
        description = "Path to custom Rofi theme";
      };
    };

    extraUtilities = {
      waybar = mkEnableOption "Enable Waybar status bar" // {
        default = true;
      };
      mako = mkEnableOption "Enable Mako notification daemon" // {
        default = true;
      };
      swaylock = mkEnableOption "Enable Swaylock screen locker" // {
        default = false;
      };
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra Niri settings merged into the configuration";
      example = literalExpression ''
        {
          prefer-no-csd = true;
          binds = {
            "Mod+T" = "spawn" "ghostty";
          };
        }
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration lines appended to config.kdl";
      example = ''
        spawn-at-startup "waybar"
        prefer-no-csd
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ]
    ++ optional cfg.rofi.enable cfg.rofi.package
    ++ optional cfg.extraUtilities.waybar pkgs.waybar
    ++ optional cfg.extraUtilities.mako pkgs.mako
    ++ optional cfg.extraUtilities.swaylock pkgs.swaylock;

    xdg.configFile."niri/config.kdl".text = ''
      // Generated Niri configuration

      input {
          keyboard {
              xkb {
                  layout "us"
              }
          }

          touchpad {
              tap
              natural-scroll
              dwt
          }

          mouse {
              natural-scroll
          }
      }

      output "eDP-1" {
          scale 1.0
      }

      layout {
          gaps 8
          center-focused-column "never"

          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }

          default-column-width { proportion 0.5; }

          focus-ring {
              width 2
              active-color "#7fc8ff"
              inactive-color "#505050"
          }

          border {
              width 1
              active-color "#7fc8ff"
              inactive-color "#505050"
          }
      }

      ${optionalString cfg.rofi.enable ''
        binds {
            Mod+D { spawn "rofi" "-show" "drun"; }
            Mod+Shift+D { spawn "rofi" "-show" "run"; }
        }
      ''}

      ${optionalString cfg.extraUtilities.waybar ''
        spawn-at-startup "waybar"
      ''}

      ${optionalString cfg.extraUtilities.mako ''
        spawn-at-startup "mako"
      ''}

      binds {
          Mod+Shift+Slash { show-hotkey-overlay; }
          Mod+T { spawn "ghostty"; }
          Mod+Q { close-window; }

          Mod+Left  { focus-column-left; }
          Mod+Down  { focus-window-down; }
          Mod+Up    { focus-window-up; }
          Mod+Right { focus-column-right; }
          Mod+H     { focus-column-left; }
          Mod+J     { focus-window-down; }
          Mod+K     { focus-window-up; }
          Mod+L     { focus-column-right; }

          Mod+Shift+Left  { move-column-left; }
          Mod+Shift+Down  { move-window-down; }
          Mod+Shift+Up    { move-window-up; }
          Mod+Shift+Right { move-column-right; }
          Mod+Shift+H     { move-column-left; }
          Mod+Shift+J     { move-window-down; }
          Mod+Shift+K     { move-window-up; }
          Mod+Shift+L     { move-column-right; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }

          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+Shift+3 { move-column-to-workspace 3; }
          Mod+Shift+4 { move-column-to-workspace 4; }
          Mod+Shift+5 { move-column-to-workspace 5; }

          Mod+Comma  { consume-window-into-column; }
          Mod+Period { expel-window-from-column; }

          Mod+R { switch-preset-column-width; }
          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }

          Mod+Shift+E { quit; }
          Mod+Shift+P { power-off-monitors; }
      }

      ${cfg.extraConfig}
    '';

    # Optional: Rofi configuration if enabled
    programs.rofi = mkIf cfg.rofi.enable {
      enable = true;
      package = cfg.rofi.package;
      terminal = "${pkgs.ghostty}/bin/ghostty";
      theme = mkIf (cfg.rofi.theme != null) cfg.rofi.theme;
    };
  };
}
