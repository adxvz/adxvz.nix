{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.fastfetch;
in
{
  options.modules.fastfetch = {
    enable = mkEnableOption "Enable fastfetch with extras and configuration";
  };

  config = mkIf cfg.enable {

    home.packages = [
      pkgs.fastfetch
    ];

    programs.fastfetch = {
      enable = true;

      settings = {
        logo = {
          type = "builtin";
          height = 15;
          width = 30;
          padding = {
            top = 5;
            left = 3;
          };
        };

        modules = [
          "break"
          {
            type = "custom";
            format = "┌───────────────────────── System Information ─────────────────────────┐";
          }
          "break"
          {
            type = "host";
            key = " HW";
            keyColor = "green";
          }
          {
            type = "cpu";
            key = "│ ├";
            keyColor = "green";
          }
          {
            type = "gpu";
            key = "│ ├󰍛";
            keyColor = "green";
          }
          {
            type = "memory";
            key = "│ ├󰍛";
            keyColor = "green";
          }
          {
            type = "disk";
            key = "└ └";
            keyColor = "green";
          }
          "break"
          {
            type = "os";
            key = " OS";
            keyColor = "yellow";
          }
          {
            type = "kernel";
            key = "│ ├";
            keyColor = "yellow";
          }
          {
            type = "bios";
            key = "│ ├";
            keyColor = "yellow";
          }
          {
            type = "packages";
            key = "│ ├󰏖";
            keyColor = "yellow";
          }
          {
            type = "shell";
            key = "└ └";
            keyColor = "yellow";
          }
          "break"
          {
            type = "de";
            key = " DE";
            keyColor = "blue";
          }
          {
            type = "lm";
            key = "│ ├";
            keyColor = "blue";
          }
          {
            type = "wm";
            key = "│ ├";
            keyColor = "blue";
          }
          {
            type = "wmtheme";
            key = "│ ├󰉼";
            keyColor = "blue";
          }
          {
            type = "terminal";
            key = "└ └";
            keyColor = "blue";
          }
          "break"
          {
            type = "uptime";
            key = " Uptime ";
            keyColor = "magenta";
          }
          {
            type = "datetime";
            key = "  DateTime ";
            keyColor = "magenta";
          }
          {
            type = "localip";
            key = "  Local IP ";
            keyColor = "magenta";
          }
          {
            type = "publicip";
            key = "  Public IP ";
            keyColor = "magenta";
          }
          "break"
          {
            type = "custom";
            format = "└──────────────────────────────────────────────────────────────────────┘";
          }
          "break"
          {
            type = "colors";
            paddingLeft = 20;
            symbol = "circle";
          }
        ];
      };
    };
  };
}
