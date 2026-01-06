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
      nixpkgs = inputs.nixos-unstable;
      utils = import ./lib/utils.nix { inherit self inputs pkgs; };
      pkgs = utils.mkPkgs { };
      flakeUtils = import ./lib/vars.nix { inherit self inputs; };
      vars = flakeUtils.vars;
      versions = flakeUtils.versions;

    in
    {
      inherit utils;

      #=========================================#
      #         Mac M1 Max                      #
      #=========================================#
      darwinConfigurations."m1max" = utils.mkSystem {
        name = "m1max";
        darwin = true;

        extraDarwinModules = [ ];

      };

      #=========================================#
      #         Surface Pro 9                   #
      #=========================================#

      nixosConfigurations.surface = utils.mkSystem {
        name = "surface";
        targetSystem = "x86_64-linux";
        hm = false;

        extraNixosModules = [
          inputs.nixos-hardware.nixosModules.microsoft-surface-common
          inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
          inputs.nixos-hardware.nixosModules.microsoft-surface-pro-9
        ];
      };

      #=========================================#
      #         Home Manager (Standalone)       #
      #=========================================#

      homeConfigurations."adxvz" = utils.mkStandaloneHome {
        name = "adxvz";
        targetSystem = "";
      };

      #=========================================#
      #         Homelab Servers                 #
      #=========================================#

      nixosConfigurations.do = utils.mkSystem {
        name = "do";
        targetSystem = "x86_64-linux";
        hm = false;
      };
      nixosConfigurations.re = utils.mkSystem {
        name = "re";
        targetSystem = "x86_64-linux";
        hm = false;
      };
      nixosConfigurations.mi = utils.mkSystem {
        name = "mi";
        targetSystem = "x86_64-linux";
        hm = false;
      };
      nixosConfigurations.fa = utils.mkSystem {
        name = "fa";
        targetSystem = "x86_64-linux";
        hm = false;
      };
      nixosConfigurations.so = utils.mkSystem {
        name = "so";
        targetSystem = "x86_64-linux";
        hm = false;
      };
      nixosConfigurations.la = utils.mkSystem {
        name = "la";
        targetSystem = "x86_64-linux";
        hm = false;
      };
      nixosConfigurations.ti = utils.mkSystem {
        name = "ti";
        targetSystem = "x86_64-linux";
        hm = false;
      };

      #=========================================#
      #    Modules, Overlays                    #
      #=========================================#

      darwinModules = {
        fonts = import ./modules/darwin/fonts.nix;
        hunspell = import ./modules/darwin/hunspell.nix;
        nix = import ./modules/darwin/nix.nix;
        socket-vmnet = import ./modules/darwin/socket-vmnet.nix;
        tuptime = import ./modules/darwin/tuptime.nix;
      };

      homeManagerModules = {

        # Shells
        fish = import ./modules/home/shells/fish.nix;
        nushell = import ./modules/home/shells/nushell.nix;
        zsh = import ./modules/home/shells/zsh.nix;

        # Terminals
        ghostty = import ./modules/home/terminals/ghostty.nix;
        wezterm = import ./modules/home/terminals/wezterm.nix;

        # CLI Tools
        scripts = import ./modules/home/cli/scripts.nix;
        ssh = import ./modules/home/cli/ssh.nix;
        gpg = import ./modules/home/cli/gpg.nix;
        git = import ./modules/home/cli/git.nix;
        jujutsu = import ./modules/home/cli/jujutsu.nix;

        # Window Managers
        niri = import ./modules/home/wm/niri.nix;

        # Applications
        emacs = import ./modules/home/apps/emacs.nix;

      };

      nixosModules = {
        nix = import ./modules/nixos/nix.nix;
        thermald = import ./modules/nixos/surface/thermald.nix;
        apfs = import ./modules/nixos/surface/apfs.nix;
        audio = import ./modules/nixos/surface/audio.nix;
        iptsd = import ./modules/nixos/surface/iptsd.nix;
        # sp8Edid = import ./modules/nixos/surface/sp8Edid.nix;
      };

      overlays = {
        nixos-option = import ./overlays/tools/nix/nixos-option.nix;
        emacs = import ./overlays/applications/editors/emacs.nix;
      };
    };
}
