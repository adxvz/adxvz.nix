{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;

let
  cfg = config.programs.niri;
  niriConfigDir = ../../home/dots/niri; # Path inside the flake
in
{
  options.programs.niri = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable Niri window manager via Home Manager.";
    };

    stylix = mkOption {
      default = false;
      type = types.bool;
      description = "Optionally enable stylix styling for Niri.";
    };
  };

  config = mkIf cfg.enable {

    # Copy Niri config from flake folder into .config/niri/
    home.file = lib.optionalAttrs (builtins.pathExists niriConfigDir) {
      ".config/niri" = {
        source = niriConfigDir;
        recursive = true;
      };
    };

    # Optional environment variable for stylix integration
    home.sessionVariables = lib.optionalAttrs cfg.stylix {
      NIRI_STYLE = "stylix";
    };

    # Ensure Niri package is available
    home.packages = [ pkgs.niri ];

  };
}
