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
    # Export wrapper script path so platforms can use it
    environment.etc."tuptimed.sh".text = tuptimed;
  };
}
