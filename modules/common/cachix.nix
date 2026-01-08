{ lib, config, ... }:

let
  cfg = config.modules.cachix;
in
{
  options.modules.cachix = {
    enable = lib.mkEnableOption "Enable Cachix binary cache";

    cacheName = lib.mkOption {
      type = lib.types.str;
      default = "adxvz";
      description = "Cachix cache name";
    };

    publicKey = lib.mkOption {
      type = lib.types.str;
      default = "adxvz.cachix.org-1:Z9+sZ/yj9AGP6eOPRn5AGRE6yINzSElz2D9GQXwckts=";
      description = "Public key for the Cachix cache";
    };
  };

  config = lib.mkIf cfg.enable {
    nixConfig = {
      extra-substituters = [
        "https://${cfg.cacheName}.cachix.org"
      ];

      extra-trusted-public-keys = [
        "${cfg.cacheName}.cachix.org-1:${cfg.publicKey}"
      ];
    };
  };
}
