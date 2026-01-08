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

  # Converts attribute sets to a list of values
  attrsToValues = attrs: nixpkgs.lib.attrsets.mapAttrsToList (_: value: value) attrs;

  # Only include a path if it exists
  pathIfExists = p: if builtins.pathExists p then p else null;

  # Filter nulls from import lists
  cleanImports = imports: builtins.filter (x: x != null) imports;

  # Create pkgs with overlays
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

  # Call package helper
  callPkg = package: (mkPkgs { }).callPackage package { };

  #========================#
  # Home Manager Module
  #========================#
  mkHomeManagerModule =
    {
      name,
      version ? versions.homeManager.stateVersion,
      ...
    }:
    let
      basePath = self;
      user = vars.primaryUser;

      # Common + platform-wide files
      sharedHome = basePath + "/home/shared.nix";
      darwinHome = basePath + "/home/darwin";
      nixosHome = basePath + "/home/nixos";

      # Host-specific files
      hostDarwinHome = basePath + "/home/darwin/${name}.nix";
      hostNixosHome = basePath + "/home/nixos/${name}.nix";

      # Helper: include only if exists
      pathIfExists = p: if builtins.pathExists p then p else null;

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
            (pathIfExists sharedHome)
            (if pkgs.stdenv.isDarwin then pathIfExists darwinHome else pathIfExists nixosHome)
            (if pkgs.stdenv.isDarwin then pathIfExists hostDarwinHome else pathIfExists hostNixosHome)
          ];
        };

        sharedModules = [
          { home.stateVersion = version; }
        ]
        ++ (attrsToValues self.homeManagerModules);
      };
    };

  #========================#
  # Darwin System
  #========================#
  mkDarwin =
    {
      name,
      hm ? true,
      extraModules ? [ ],
      extraDarwinModules ? [ ],
      systemName ? name,
      ...
    }:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          self
          vars
          versions
          nixpkgs
          systemName
          ;
        pkgs = mkPkgs { };
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
        (mkHomeManagerModule {
          inherit name;
          version = versions.homeManager.stateVersion;
        })
      ];
    };

  #========================#
  # NixOS System
  #========================#
  mkNixos =
    {
      name,
      targetSystem ? vars.currentSystem,
      lab ? false,
      role ? null,
      extraModules ? [ ],
      extraNixosModules ? [ ],
      hm ? true,
      ...
    }:

    let
      # Common modules applied first
      baseModules = [
        ../hosts/nixos/minimal.nix
      ];

      # Machine-specific module (imports hardware-configuration.nix inside)
      hostModule = pathIfExists (../hosts/nixos + "/${name}");

      # Optional lab / role modules
      labModules = builtins.filter (x: x != null) [
        (if lab then pathIfExists (../lab/nodes + "/${name}") else null)
        (if lab && role != null then pathIfExists (../lab/roles + "/${role}.nix") else null)
      ];
    in
    nixpkgs.lib.nixosSystem {
      system = targetSystem;

      modules = builtins.filter (x: x != null) (
        baseModules
        ++ [ hostModule ] # always load machine-specific
        ++ labModules
        ++ extraModules
        ++ extraNixosModules
        ++ (attrsToValues self.nixosModules)
        ++ (
          if hm then
            [
              inputs.home-manager.nixosModules.home-manager
              (mkHomeManagerModule {
                inherit name;
                version = versions.homeManager.stateVersion;
              })
            ]
          else
            [ ]
        )
      );

      specialArgs = {
        inherit
          vars
          versions
          nixpkgs
          self
          name
          lab
          role
          ;
      };
    };

  #========================#
  # Generic mkSystem
  #========================#
  mkSystem =
    {
      name,
      darwin ? false,
      targetSystem ? vars.currentSystem,
      pkgs ? inputs.nixos-unstable,
      configuration ? null,
      hm ? true,
      lab ? false,
      role ? null,
      extraModules ? [ ],
      extraNixosModules ? [ ],
      extraDarwinModules ? [ ],
      ...
    }:
    let
      systemName = name;
    in
    if darwin then
      mkDarwin {
        inherit
          name
          hm
          extraModules
          extraDarwinModules
          systemName
          ;
      }
    else
      mkNixos {
        inherit
          name
          targetSystem
          pkgs
          hm
          extraModules
          extraNixosModules
          systemName
          lab
          role
          configuration
          ;
      };
}
