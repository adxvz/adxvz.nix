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

  # --------------------
  # Emacs base package
  # --------------------
  emacsBase = if isDarwin && pkgs ? emacs-plus then pkgs.emacs-plus else pkgs.emacs;

  emacsPkg = (pkgs.emacsPackagesFor emacsBase).emacsWithPackages (
    epkgs:
    let
      defaultPkgs = [
        vterm
        treesit-grammars.with-all-grammars
      ];
      orgPkg = optionals cfg.org.enable [ epkgs.org ];
    in
    defaultPkgs ++ orgPkg
  );

  # --------------------
  # Haskell packages
  # --------------------
  defaultHaskellPkgs = [
    pkgs.ghc
    pkgs.haskellPackages.haskellLanguageServer
    pkgs.latex
    pkgs.convert
    pkgs.pdftotext
  ];
  haskellPkgs = cfg.haskellPackages or defaultHaskellPkgs;

  # --------------------
  # TeXLive packages
  # --------------------
  defaultTexPkgs = [
    pkgs.dvipng
    pkgs.texlive.combined.scheme-full
  ];
  texPkgs = cfg.texlivePackages or defaultTexPkgs;

in
{
  # --------------------
  # Options
  # --------------------
  options.modules.emacs = {
    enable = mkEnableOption "Enable Emacs configuration";

    org.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Org mode package in Emacs.";
    };

    haskellPackages = mkOption {
      type = types.listOf types.package;
      default = defaultHaskellPkgs;
      description = "Extra Haskell-related packages to install alongside Emacs.";
    };

    texlivePackages = mkOption {
      type = types.listOf types.package;
      default = defaultTexPkgs;
      description = "TeXLive packages to install alongside Emacs.";
    };

    daemon.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Run Emacs as a background daemon.";
    };
  };

  # --------------------
  # Configuration
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
    ++ haskellPkgs
    ++ texPkgs;

    # --------------------
    # Copy custom Emacs config from flake to home
    # --------------------
    home.file.".emacs.d/init.el".source = ./config/init.el;
    home.file.".emacs.d/ews.el".source = ./config/ews.el;

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
          lib.makeBinPath ([
            emacsPkg
            pkgs.git
            pkgs.ripgrep
            pkgs.fd
          ])
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
