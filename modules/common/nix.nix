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
      description = "Enable custom nix environment configuration.";
    };

    allowUnfree = mkOption {
      type = types.bool;
      default = true;
      description = "Allow unfree packages from nixpkgs.";
    };
  };

  config = mkIf cfg.enable {
    # Environment configuration
    environment.etc = {
      "nix/current".source = self;
      "nix/nixpkgs".source = nixpkgs;
    };

    environment.systemPackages = with pkgs; [
      nil
      niv
      nixd
      nix-index
      nix-index-update
      nvd
    ];

    # Nix configuration
    nix = {
      channel.enable = false;
      nixPath = [ "nixpkgs=${nixpkgs}" ];

      # Registries
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

        # Allow unfree packages if requested
        allow-unfree = cfg.allowUnfree;
      };
    };

    # Flake-specific configuration
    nixpkgs.flake = {
      setNixPath = false;
      setFlakeRegistry = false;
    };
  };
}
