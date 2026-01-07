{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.emacs;
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  /*
    External tools used by Emacs (NOT Emacs Lisp packages)
    These are always safe in home.packages.
  */
  commonPkgs = with pkgs; [
    hunspell
    ghostscript
    poppler
    djvulibre
    mpg123
    mpv
    mupdf
    imagemagick
    graphviz
    texlive.combined.scheme-basic
  ];

  linuxPkgs = with pkgs; [
    libreoffice
    ripgrep
    maim
  ];

  darwinPkgs = with pkgs; [
    ripgrep
  ];

  /*
    Emacs Lisp packages
    IMPORTANT:
    - Used ONLY on Linux via Home Manager
    - On Darwin, Emacs installs these itself (Elpaca/straight/etc.)
  */
  coreEmacsPackages =
    epkgs: with epkgs; [
      use-package
      spacious-padding
      modus-themes
      ef-themes
      mixed-pitch
      vertico
      orderless
      marginalia
      which-key
      helpful
      nov
      consult
      consult-notes
      olivetti
      vundo
      dictionary
      writegood-mode
      titlecase
      lorem-ipsum
      fountain-mode
      markdown-mode
      ox-epub
    ];

  orgPackages =
    epkgs: with epkgs; [
      org
      org-appear
      org-fragtog
      org-modern
      org-web-tools
    ];

  denotePackages =
    epkgs: with epkgs; [
      denote
      denote-journal
      denote-org
      denote-sequence
      denote-explore
    ];

  citarPackages =
    epkgs: with epkgs; [
      citar
      citar-denote
      biblio
    ];

  multimediaPackages =
    epkgs: with epkgs; [
      emms
      openwith
    ];

  # Compose Linux-only ELPA set
  linuxEmacsPackages =
    epkgs:
    lib.concatLists [
      (lib.optionals cfg.config (coreEmacsPackages epkgs))
      (lib.optionals cfg.enableOrg (orgPackages epkgs))
      (lib.optionals cfg.enableDenote (denotePackages epkgs))
      (lib.optionals cfg.enableCitar (citarPackages epkgs))
      (lib.optionals cfg.enableMultimedia (multimediaPackages epkgs))
      cfg.extraPackages
    ];

in
{
  ###### OPTIONS ###############################################################

  options.modules.emacs = {
    enable = lib.mkEnableOption "Emacs";

    config = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable full Emacs configuration (init / ews).";
    };

    enableOrg = lib.mkEnableOption "Org mode support";
    enableDenote = lib.mkEnableOption "Denote note-taking";
    enableCitar = lib.mkEnableOption "Citar bibliography";
    enableMultimedia = lib.mkEnableOption "EMMS multimedia";

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra Emacs Lisp packages (Linux only).";
    };
  };

  ###### CONFIG ###############################################################

  config = lib.mkIf cfg.enable {

    programs.home-manager.enable = true;

    programs.emacs = {
      enable = true;

      package = if isDarwin then pkgs.emacs-plus else pkgs.emacs;

      extraPackages = epkgs: lib.optionals isLinux (linuxEmacsPackages epkgs);

      extraConfig = lib.mkIf cfg.config ''
        ;; Load early-init first if present
        (when (file-exists-p "${config.home.homeDirectory}/.emacs.d/early-init.el")
          (load-file "${config.home.homeDirectory}/.emacs.d/early-init.el"))

        (load-file "${config.home.file."init.el".source}")
        (load-file "${config.home.file."ews.el".source}")
      '';
    };

    home.packages = commonPkgs ++ lib.optionals isLinux linuxPkgs ++ lib.optionals isDarwin darwinPkgs;

    home.file."init.el".source = lib.mkIf cfg.config ./config/init.el;

    home.file."ews.el".source = lib.mkIf cfg.config ./config/ews.el;

    home.file.".emacs.d/early-init.el".source = ./config/early-init.el;
  };
}
