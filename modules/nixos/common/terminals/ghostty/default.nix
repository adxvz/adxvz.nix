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
  # Define the option under modules.ghostty
  options.modules.ghostty = {
    enable = mkEnableOption "Enable ghostty terminal";
    port = mkOption {
      type = types.int;
      default = 2222;
      description = "Port ghostty should listen on";
    };
  };

  config = mkIf cfg.enable {
    # Install the ghostty package
    environment.systemPackages = [ pkgs.ghostty ];

    # Configure the systemd service
    # systemd.services.ghostty = {
    #   description = "Ghostty terminal server";
    #   after = [ "network.target" ];
    #   wantedBy = [ "multi-user.target" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.ghostty}/bin/ghostty -p ${toString cfg.port}";
    #     Restart = "always";
    #   };
    # };
  };
}
