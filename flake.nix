{
  description = ".:: One Flake to Rule them ALL [ An exhaustive configuration for all things NIX ] ::.";

  inputs = {
    # Nix Package Manager
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    comma = {
      url = "github:nix-community/comma";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    nixos-anywhere = {
      url = "github:numtide/nixos-anywhere";
      inputs.nixpkgs.follows = "nixos-unstable";
      inputs.disko.follows = "disko";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote.url = "github:nix-community/lanzaboote";

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

    jujutsu = {
      url = "github:jj-vcs/jj";
      inputs.nixpkgs.follows = "nixos-unstable";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    agenix.url = "github:ryantm/agenix";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    authentik-nix = {
      url = "github:nix-community/authentik-nix";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    trellis-cli = {
      url = "github:roots/homebrew-tap";
      flake = false;
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      flakeUtils = import ./lib/vars.nix { inherit self inputs; };
      vars = flakeUtils.vars;
      versions = flakeUtils.versions;
      utils = import ./lib/utils.nix { inherit self inputs pkgs; };
      pkgs = utils.mkPkgs { };
      modules = import ./lib/modules.nix { inherit pkgs inputs utils; };
    in
    {
      inherit utils;

      darwinModules = modules.darwinModules;
      nixosModules = modules.nixosModules;
      homeManagerModules = modules.homeManagerModules;

      overlays = {
        nixos-option = import ./overlays/tools/nix/nixos-option.nix;
        emacs = import ./overlays/applications/editors/emacs.nix;
      };

      darwinConfigurations."m1max" = utils.mkSystem {
        name = "m1max";
        darwin = true;
        extraDarwinModules = [ ];
      };

      nixosConfigurations = {
        surface = utils.mkSystem {
          name = "surface";
          targetSystem = "x86_64-linux";
          extraNixosModules = [
            inputs.nixos-hardware.nixosModules.microsoft-surface-common
            inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
            inputs.nixos-hardware.nixosModules.microsoft-surface-pro-9
          ];
        };

        mini = utils.mkSystem {
          name = "mini";
          targetSystem = "x86_64-linux";
        };

        # Homelab Servers
        do = utils.mkSystem {
          name = "do";
          targetSystem = "x86_64-linux";
          hm = false;
          lab = true;
          role = "master";
        };

        re = utils.mkSystem {
          name = "re";
          targetSystem = "x86_64-linux";
          hm = false;
          lab = true;
          role = "master";
        };

        mi = utils.mkSystem {
          name = "mi";
          targetSystem = "x86_64-linux";
          hm = false;
          lab = true;
          role = "master";
        };

        fa = utils.mkSystem {
          name = "fa";
          targetSystem = "x86_64-linux";
          hm = false;
          lab = true;
          role = "worker";
        };

        so = utils.mkSystem {
          name = "so";
          targetSystem = "x86_64-linux";
          hm = false;
          lab = true;
          role = "worker";
        };

        la = utils.mkSystem {
          name = "la";
          targetSystem = "x86_64-linux";
          hm = false;
          lab = true;
          role = "worker";
        };

        ti = utils.mkSystem {
          name = "ti";
          targetSystem = "x86_64-linux";
          hm = false;
          lab = true;
          role = "storage";
        };
      };
    };
}
