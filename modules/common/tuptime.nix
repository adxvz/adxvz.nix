{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.tuptime;

  tuptimed = pkgs.writeShellScript "tuptimed" ''
    LOGDIR="/var/log/tuptime"
    mkdir -p "$LOGDIR"
    chmod 755 "$LOGDIR"

    function shutdown() {
      ${pkgs.tuptime}/bin/tuptime -q -g
      exit 0
    }

    function startup() {
      ${pkgs.tuptime}/bin/tuptime -q
      tail -f /dev/null &
      wait $!
    }

    trap shutdown SIGTERM
    startup
  '';
in
{
  options.modules.tuptime = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable tuptime monitoring service";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tuptime ];

    # macOS launchd service
    launchd.daemons.tuptime = mkIf pkgs.stdenv.isDarwin {
      serviceConfig = {
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "/bin/wait4path ${pkgs.tuptime} && ${tuptimed}"
        ];
        RunAtLoad = true;
        StandardOutPath = "/var/log/tuptime/stdout";
        StandardErrorPath = "/var/log/tuptime/stderr";
      };
    };
  };
}
