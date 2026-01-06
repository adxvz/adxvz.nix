{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.emacs;

  # Common external tools required on both Linux and Darwin
  commonPkgs = with pkgs; [
    emacs
    git
    curl
    zip
    hunspell
    ghostscript
    poppler # pdftotext
    djvulibre # ddjvu
    mpg123
    mpv
    vlc
    mupdf
    ripgrep
    libreoffice
    imagemagick # convert
    texlive.combined.scheme-basic
    graphviz # org-babel dot support
    gimp
  ];

  # Linux-specific packages
  linuxPkgs = with pkgs; [

  ];

  # Darwin/macOS-specific packages
  darwinPkgs = with pkgs; [

  ];

  # Emacs packages to install via use-package
  emacsPackages = with pkgs.emacsPackages; [
    use-package
    spacious-padding
    modus-themes
    ef-themes
    mixed-pitch
    balanced-windows
    vertico
    savehist
    orderless
    marginalia
    which-key
    helpful
    flyspell
    org
    org-appear
    org-fragtog
    org-modern
    doc-view
    nov
    bibtex
    biblio
    citar
    elfeed
    elfeed-org
    org-web-tools
    emms
    openwith
    denote
    denote-journal
    denote-org
    denote-sequence
    consult
    consult-notes
    citar-denote
    denote-explore
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

in
{
  options.modules.emacs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Emacs configuration.";
    };

    org = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Org mode package in Emacs.";
      };
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
      extraPackages = epkgs: emacsPackages ++ cfg.extraPackages;
    };

    # Platform-specific system dependencies
    home.packages =
      commonPkgs
      ++ lib.optionals pkgs.stdenv.isLinux linuxPkgs
      ++ lib.optionals pkgs.stdenv.isDarwin darwinPkgs;
  };
}
