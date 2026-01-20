{
  config,
  lib,
  pkgs,
  nixpkgs,
  self,
  versions,
  ...
}:
with lib;
let
  cfg = config.modules.nix;
  mkRegistry = id: branch: {
    from = {
      inherit id;
      type = "indirect";
    };
    to = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = branch;
    };
  };
in
{
  options.modules.nix = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable custom Nix configuration";
    };
  };

  config = mkIf cfg.enable {
    environment.etc = {
      "nix/current".source = self;
      "nix/nixpkgs".source = nixpkgs;
    };

    environment.systemPackages = with pkgs; [
      nil
      niv
      nixd
      nix-index
      nvd
    ];

    nix = {
      channel.enable = false;
      nixPath = [ "nixpkgs=${nixpkgs}" ];

      # Use local nixpkgs
      registry = {
        nixpkgs = {
          from = {
            id = "nixpkgs";
            type = "indirect";
          };
          to = lib.mkForce {
            path = "${nixpkgs}";
            type = "path";
          };
        };
        nixos-stable = mkRegistry "nixos-stable" "nixos-${versions.nixos.stableVersion}";
        nixos-unstable = mkRegistry "nixos-unstable" "nixos-unstable";
      };

      optimise.automatic = true;

      settings = {
        experimental-features = "nix-command flakes";
        narinfo-cache-positive-ttl = 604800;
        keep-outputs = true;
        keep-derivations = true;
        trusted-users = [
          "root"
          "adxvz"
          "@wheel"
        ];
        # Allow unfree packages
        allow-unfree = true;
      };
    };

    # Also set nixpkgs config for the system
    nixpkgs.config.allowUnfree = true;
  };
}
