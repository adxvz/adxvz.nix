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

  homeDir = config.home.homeDirectory;
  emacsConfigDir = cfg.configPath or "${config.home.file."emacs"}";

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
in
{
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
      type = types.path;
      default = "./init.el";
      description = "Optional path to Emacs configuration (e.g., inside the nix flake). Defaults to ~/.config/emacs";
    };
  };

  config = mkIf (cfg.enable) {
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

    # Deploy Emacs configuration from flake path if provided
    home.file.".config/emacs" = mkIf cfg.configPath {
      source = cfg.configPath;
    };

    # ----------------------------
    # Emacs daemon (Linux: systemd)
    # ----------------------------
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

    # -----------------------------
    # Emacs daemon (macOS: launchd)
    # -----------------------------
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
