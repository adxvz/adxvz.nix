{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.emacs;

  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Base Emacs package with optional features
  emacsPkg =
    let
      baseEmacs = if isDarwin && pkgs ? emacs-plus then pkgs.emacs-plus else pkgs.emacs;
    in
    (pkgs.emacsPackagesFor baseEmacs).emacsWithPackages (
      epkgs:
      with epkgs;
      [
        vterm
        treesit-grammars.with-all-grammars
      ]
      ++ optionals cfg.org.enable [ org ]
    );

  haskellPkgs = cfg.haskellPackages;

  # Default Emacs config path inside the flake
  defaultConfigPath = ./config;

  # Writable ELN cache directory for native compilation
  elnCacheDir = "${config.home.homeDirectory}/.config/emacs/eln-cache";

in
{
  # --------------------
  # Option declarations
  # --------------------
  options.modules.emacs = {
    enable = mkEnableOption "Emacs configuration";

    org.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Org mode package in Emacs.";
    };

    haskellPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExample "[ pkgs.ghc pkgs.haskellPackages.haskellLanguageServer ]";
      description = "Extra Haskell-related packages to install alongside Emacs.";
    };

    daemon.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Run Emacs as a background daemon.";
    };

    configPath = mkOption {
      type = types.nullOr types.path;
      default = defaultConfigPath;
      description = "Path to Emacs configuration inside the flake.";
    };
  };

  # --------------------
  # Module configuration
  # --------------------
  config = mkIf cfg.enable {
    home.packages = [
      emacsPkg
      pkgs.git
      pkgs.ripgrep
      pkgs.fd
      pkgs.pandoc
      pkgs.luajitPackages.luacheck
      pkgs.luajitPackages.lua-lsp
    ]
    ++ haskellPkgs;

    # Deploy Emacs configuration from flake folder
    home.file.".config/emacs" = {
      source = cfg.configPath;
    };

    # Ensure ELN cache exists for native compilation
    home.directories = [ elnCacheDir ];

    # Linux systemd daemon
    systemd.user.services.emacs = mkIf (cfg.daemon.enable && isLinux) {
      Unit = {
        Description = "Emacs text editor daemon";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${emacsPkg}/bin/emacs --fg-daemon";
        Restart = "on-failure";
        Environment = "PATH=${
          lib.makeBinPath [
            emacsPkg
            pkgs.git
            pkgs.ripgrep
            pkgs.fd
          ]
        }";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    # macOS launchd daemon
    launchd.agents.emacs = mkIf (cfg.daemon.enable && isDarwin) {
      enable = true;
      config = {
        ProgramArguments = [
          "${emacsPkg}/bin/emacs"
          "--daemon"
        ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  };
}
