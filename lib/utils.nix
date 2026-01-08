{
  self,
  inputs,
  pkgs,
  ...
}:
let
  flakeUtils = import ../lib/vars.nix { inherit self inputs; };
  vars = flakeUtils.vars;
  versions = flakeUtils.versions;
  nixpkgs = inputs.nixos-unstable;
in
rec {
  attrsToValues = attrs: nixpkgs.lib.attrsets.mapAttrsToList (_: value: value) attrs;

  mkPkgs =
    {
      system ? vars.currentSystem,
      nixpkgs ? inputs.nixos-unstable,
    }:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.emacs-overlay.overlay
        inputs.apple-silicon.overlays.apple-silicon-overlay
        inputs.nix-alien.overlays.default
      ]
      ++ (attrsToValues self.overlays);
    };

  callPkg = package: (mkPkgs { }).callPackage package { };

  mkHomeManagerModule =
    {
      name,
      version ? versions.homeManager.stateVersion,
      ...
    }:
    let
      basePath = self;
      user = vars.primaryUser;

      # Paths
      commonHome = basePath + "/home/common.nix";

      # Darwin paths
      darwinHome = basePath + "/home/darwin.nix";
      hostDarwinHome = ../home/darwin + "/${name}.nix";

      # NixOS/Linux paths
      nixosHome = basePath + "/home/nixos.nix";
      hostNixosHome = ../home/nixos + "/${name}.nix";

      # helper
      assertExists = path: if builtins.pathExists path then path else null;
    in
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";

        extraSpecialArgs = {
          systemName = name;
          inherit inputs self;
          pkgsStable = mkPkgs { nixpkgs = inputs.nixos-stable; };
        };

        users.${user} = {
          imports = builtins.filter (x: x != null) [
            (assertExists commonHome)

            # Darwin
            (assertExists darwinHome)
            (
              if pkgs.stdenv.isDarwin then
                (if builtins.pathExists hostDarwinHome then hostDarwinHome else null)
              else
                null
            )

            # Linux / NixOS
            (assertExists nixosHome)
            (
              if pkgs.stdenv.isLinux then
                (if builtins.pathExists hostNixosHome then hostNixosHome else null)
              else
                null
            )
          ];
        };

        sharedModules = [
          { home.stateVersion = version; }
        ]
        ++ (attrsToValues self.homeManagerModules);
      };
    };

  mkStandaloneHome =
    {
      name,
      system ? builtins.currentSystem,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs { inherit system; };

      modules = [
        ../home/common.nix

        {
          home.username = vars.primaryUser;
          home.homeDirectory =
            if pkgs.stdenv.isDarwin then "/Users/${vars.primaryUser}" else "/home/${vars.primaryUser}";

          home.stateVersion = versions.homeManager.stateVersion;
        }
      ]

      ++ nixpkgs.lib.optionals pkgs.stdenv.isDarwin [
        (../home/darwin + "/${name}.nix")
      ]

      ++ nixpkgs.lib.optionals pkgs.stdenv.isLinux [
        (../home/nixos + "/${name}.nix")
      ]

      ++ (attrsToValues self.homeManagerModules);

      extraSpecialArgs = {
        inherit
          inputs
          self
          vars
          versions
          ;
        systemName = name;
      };
    };

  mkDarwin =
    {
      name,
      hm ? true,
      darwin ? false,
      extraModules ? [ ],
      extraDarwinModules ? [ ],

    }:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          self
          vars
          versions
          nixpkgs
          ;
        systemName = name;
      };
      modules = [
        { nixpkgs.pkgs = mkPkgs { }; }
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = vars.primaryUser;
            autoMigrate = true;
            mutableTaps = false;
            taps = {
              "homebrew/homebrew-core" = inputs."homebrew-core";
              "homebrew/homebrew-cask" = inputs."homebrew-cask";
              "homebrew/homebrew-bundle" = inputs."homebrew-bundle";
              "roots/homebrew-tap" = inputs."trellis-cli";
            };
          };
          system = {
            stateVersion = versions.darwin.stateVersion;
            configurationRevision = versions.rev;
          };
        }
        (../hosts/darwin + "/${name}")
      ]
      ++ (attrsToValues self.darwinModules)
      ++ extraModules
      ++ extraDarwinModules
      ++ nixpkgs.lib.optionals hm [
        inputs.home-manager.darwinModules.home-manager
        (mkHomeManagerModule { inherit name darwin; })
      ];
    };

  mkNixos =
    {
      name,
      targetSystem ? vars.currentSystem,
      nixpkgs ? inputs.nixos-unstable,
      configuration ? {
        imports = [ (../hosts/nixos + "/${name}.nix") ];
      },
      hm ? true,
      darwin ? false,

      extraModules ? [ ],
      extraNixosModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit vars versions nixpkgs;
        self = self;
        systemName = name;
        pkgsStable = mkPkgs {
          system = targetSystem;
          nixpkgs = inputs.nixos-stable;
        };
      };
      modules = [
        configuration
        (../hosts/nixos + "/${name}")
      ]

      ++ (attrsToValues self.nixosModules)
      ++ extraModules
      ++ extraNixosModules
      ++ nixpkgs.lib.optionals hm [
        inputs.home-manager.nixosModules.home-manager
        (mkHomeManagerModule { inherit name darwin; })
      ];
    };

  mkSystem =
    {
      name,
      darwin ? false,
      nixos ? false,
      targetSystem ? vars.currentSystem,
      nixpkgs ? inputs.nixos-unstable,
      hostPkgs ? mkPkgs { },
      configuration ? null,
      hm ? true,
      extraModules ? [ ],
      extraNixosModules ? [ ],
      extraDarwinModules ? [ ],
      ...
    }:
    if darwin then
      mkDarwin {
        inherit
          name
          hm
          darwin
          extraModules
          extraDarwinModules
          ;
      }
    else
      mkNixos {
        inherit
          name
          targetSystem
          nixpkgs
          hm
          darwin
          extraModules
          extraNixosModules

          ;
        configuration =
          if configuration != null then
            configuration
          else
            {
              imports = [ (../hosts/nixos + "/${name}") ];
            };
      };
}
