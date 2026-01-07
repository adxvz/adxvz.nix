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
  options.modules.bat = {
    enable = mkEnableOption "Enable bat with extras and configuration";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        pager = "less -FR";
        style = "full";
        theme = mkForce "Dracula";
      };
      extraPackages = with pkgs.bat-extras; [
        batman
        batpipe
        batgrep
      ];
    };

    home.sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
    };
  };
}
