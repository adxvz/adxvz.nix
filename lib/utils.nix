{
  self,
  inputs,
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

  callPkg = package: (mkPkgs { }).callPackage package { inherit ; };

  mkHomeManagerModule =
    {
      name,
      version ? versions.homeManager.stateVersion,
      darwin ? false,
      ...
    }:
    let
      # Base path of the repo / flake
      basePath = self;

      # Determine the correct user config file based on flake flags
      userHomeConfig =
        if darwin && builtins.pathExists (basePath + "/home/darwin/${vars.primaryUser}.nix") then
          basePath + "/home/darwin/${vars.primaryUser}.nix"
        else if builtins.pathExists (basePath + "/home/nixos/${vars.primaryUser}.nix") then
          basePath + "/home/nixos/${vars.primaryUser}.nix"
        else
          throw "No Home Manager config found for user ${vars.primaryUser}";
    in
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "";

        extraSpecialArgs = {
          systemName = name;
          inherit inputs self;
          pkgsStable = mkPkgs { nixpkgs = inputs.nixos-stable; };
        };

        users = {
          # Assign the selected Home Manager config
          ${vars.primaryUser} = userHomeConfig;
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
      system ? vars.currentSystem,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs { inherit system; };
      modules = [
        (../home/darwin + "/${name}.nix")
      ]
      ++ (attrsToValues self.homeManagerModules);
      extraSpecialArgs = { inherit inputs self; };
    };

  mkDarwin =
    {
      name,
      hm ? true,
      darwin ? false,
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
      ...
    }:
    if darwin then
      mkDarwin {
        inherit
          name
          hm
          darwin
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
