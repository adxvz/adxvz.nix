{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.bat;
in
{
  options.modules.atuin = {
    enable = mkEnableOption "Enable atuin with extras and configuration";
  };

  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      settings = {
        dialect = "uk";
        timezone = "local";
        auto_sync = true;
        update_check = true;
      };
    };
  };
}
