{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.atuin;
in
{
  options.modules.atuin = {
    enable = mkEnableOption "Enable Atuin shell history";

    daemon = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the Atuin background daemon";
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
      enable = mkEnableOption "Use a custom/self-hosted Atuin server";

      address = mkOption {
        type = types.str;
        default = "";
        description = "Custom Atuin server address";
      };
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra Atuin settings merged into programs.atuin.settings";
    };
  };

  config = mkIf cfg.enable {
    # Ensure atuin is installed by the module itself
    home.packages = [
      pkgs.atuin
    ];

    programs.atuin = {
      enable = true;

      daemon.enable = cfg.daemon;

      enableBashIntegration = cfg.shells.bash;
      enableFishIntegration = cfg.shells.fish;
      enableZshIntegration = cfg.shells.zsh;
      enableNushellIntegration = cfg.shells.nushell;

      settings = {
        dialect = "uk";
        timezone = "local";
        auto_sync = true;
        update_check = true;
      }
      // cfg.settings
      // optionalAttrs cfg.server.enable {
        sync_address = cfg.server.address;
      };
    };
  };
}
