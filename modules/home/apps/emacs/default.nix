{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.emacs;

  # Common external tools for all platforms
  commonPkgs = with pkgs; [
    emacs
    hunspell
    ghostscript
    poppler
    djvulibre
    mpg123
    mpv
    mupdf
    imagemagick
    texlive.combined.scheme-basic
    graphviz
  ];

  # Linux-specific packages
  linuxPkgs = with pkgs; [
    libreoffice
    ripgrep
    maim
  ];

  # Darwin/macOS-specific packages
  darwinPkgs = with pkgs; [
    libreoffice-still
    ripgrep
  ];

  # Core Emacs packages
  coreEmacsPackages = with pkgs.emacsPackages; [
    use-package
    spacious-padding
    modus-themes
    ef-themes
    mixed-pitch
    balanced-windows
    vertico
    orderless
    marginalia
    which-key
    helpful
    flyspell
    doc-view
    nov
    bibtex
    consult
    consult-notes
    olivetti
    vundo
    dictionary
    writegood-mode
    titlecase
    lorem-ipsum
    ediff
    fountain-mode
    markdown-mode
    ox-epub
    ox-latex
  ];

  # Optional modules
  orgPackages = with pkgs.emacsPackages; [
    org
    org-appear
    org-fragtog
    org-modern
    org-web-tools
  ];

  denotePackages = with pkgs.emacsPackages; [
    denote
    denote-journal
    denote-org
    denote-sequence
    denote-explore
  ];

  citarPackages = with pkgs.emacsPackages; [
    citar
    citar-denote
    biblio
  ];

  multimediaPackages = with pkgs.emacsPackages; [
    emms
    openwith
  ];

  # Compose full package list based on user options
  selectedPackages = lib.concatLists [
    (if cfg.config then coreEmacsPackages else [ ])
    (if cfg.enableOrg then orgPackages else [ ])
    (if cfg.enableDenote then denotePackages else [ ])
    (if cfg.enableCitar then citarPackages else [ ])
    (if cfg.enableMultimedia then multimediaPackages else [ ])
    cfg.extraPackages
  ];

in
{
  options.modules.emacs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Emacs configuration.";
    };

    config = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable full Emacs configuration (packages + init/ews).";
    };

    enableOrg = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Org mode and related packages.";
    };

    enableDenote = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Denote and note-taking packages.";
    };

    enableCitar = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Citar and bibliography management.";
    };

    enableMultimedia = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable EMMS and multimedia support.";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra Emacs packages to install via Home Manager.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.home-manager.enable = true;

    programs.emacs = {
      enable = true;
      package = pkgs.emacs;

      extraPackages = epkgs: selectedPackages;

      extraConfig = lib.mkIf cfg.config ''
        ;; Load init.el and ews.el if config is enabled
        (load-file "${config.home.file."init.el".source}")
        (load-file "${config.home.file."ews.el".source}")
      '';
    };

    home.packages =
      commonPkgs
      ++ lib.optionals pkgs.stdenv.isLinux linuxPkgs
      ++ lib.optionals pkgs.stdenv.isDarwin darwinPkgs;

    home.file."init.el".source = if cfg.config then ./init.el else null;
    home.file."ews.el".source = if cfg.config then ./ews.el else null;
  };
}
