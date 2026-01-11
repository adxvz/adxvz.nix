{
  description = " .:: One Flake to Rule them ALL [ An exhaustive configuration for all things NIX ] ::. ";

  inputs = {
    # Nix Package Manager
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    nur.url = "github:nix-community/NUR"; # Nix User Repository (Community ran repository for nix packages)
    nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

    # Declarative configuration of user specific (non-global) packages and dotfiles
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Nix modules for darwin (macOS)
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Package expressions and NixOS configuration modules to assist with installing NixOS on bare metal
    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Weekly updated nix-index database for nixos-unstable channel
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Generate outputs for different target formats with the same Nix config
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Run software without installing it (wraps nix shell -c and nix-index)
    comma = {
      url = "github:nix-community/comma";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    #Install NixOS via SSH
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

    # Choose what files/folders to keep between reboots
    impermanence.url = "github:nix-community/impermanence";

    # Secure boot for NixOS
    lanzaboote.url = "github:nix-community/lanzaboote";

    # Automatically downloads dependencies when run in a project folder.
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

    # Jujutsu (git alternative)
    jujutsu = {
      url = "github:jj-vcs/jj";
      inputs.nixpkgs.follows = "nixos-unstable";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    # Secrets Management
    agenix.url = "github:ryantm/agenix";
    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixos-unstable";

    # Ghostty
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Automatically generate network diagrams from nixos config
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Multi-profile Nix flake deployment tool
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Nix module for Identity management tool Authentik
    authentik-nix = {
      url = "github:nix-community/authentik-nix";
    };

    # Neovim (NVF)
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    # Theming framework for Nix
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Overlays

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Homebrew & Homebrew Taps

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

      #=========================================#
      #              Nix Darwin                 #
      #=========================================#
      darwinConfigurations."m1max" = utils.mkSystem {
        name = "m1max";
        darwin = true;

        extraDarwinModules = [ ];

      };

      #=========================================#
      #                  Nixos                  #
      #=========================================#

      nixosConfigurations.surface = utils.mkSystem {
        name = "surface";
        targetSystem = "x86_64-linux";

        extraNixosModules = [
          inputs.nixos-hardware.nixosModules.microsoft-surface-common
          inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
          inputs.nixos-hardware.nixosModules.microsoft-surface-pro-9
        ];
      };

      nixosConfigurations.mini = utils.mkSystem {
        name = "mini";
        targetSystem = "x86_64-linux";
        hm = false;
      };

      #=========================================#
      #            Homelab Servers              #
      #=========================================#

      nixosConfigurations.do = utils.mkSystem {
        name = "do";
        targetSystem = "x86_64-linux";
        hm = false;
        lab = true;
        role = "master";
      };
      nixosConfigurations.re = utils.mkSystem {
        name = "re";
        targetSystem = "x86_64-linux";
        hm = false;
        lab = true;
        role = "master";
      };
      nixosConfigurations.mi = utils.mkSystem {
        name = "mi";
        targetSystem = "x86_64-linux";
        hm = false;
        lab = true;
        role = "master";
      };
      nixosConfigurations.fa = utils.mkSystem {
        name = "fa";
        targetSystem = "x86_64-linux";
        hm = false;
        lab = true;
        role = "worker";
      };
      nixosConfigurations.so = utils.mkSystem {
        name = "so";
        targetSystem = "x86_64-linux";
        hm = false;
        lab = true;
        role = "worker";
      };
      nixosConfigurations.la = utils.mkSystem {
        name = "la";
        targetSystem = "x86_64-linux";
        hm = false;
        lab = true;
        role = "worker";
      };
      nixosConfigurations.ti = utils.mkSystem {
        name = "ti";
        targetSystem = "x86_64-linux";
        hm = false;
        lab = true;
        role = "storage";
      };

    };
}
