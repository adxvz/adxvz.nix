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
    hunspell
    ghostscript
    poppler # pdftotext
    djvulibre # ddjvu
    mpg123
    mpv
    mupdf
    imagemagick # convert
    texlive.combined.scheme-basic
    graphviz # org-babel dot support
  ];

  # Linux-specific packages
  linuxPkgs = with pkgs; [
    libreoffice
  ];

  # Darwin/macOS-specific packages
  darwinPkgs = with pkgs; [

  ];

  # Emacs packages to install via use-package
  emacsPackages = lib.filterAttrs (_: v: v != null) (
    with pkgs.emacsPackages;
    {
      use-package = use-package;
      modus-themes = modus-themes;
      ef-themes = ef-themes;
      mixed-pitch = mixed-pitch;
      balanced-windows = balanced-windows;
      vertico = vertico;
      orderless = orderless;
      marginalia = marginalia;
      which-key = which-key;
      helpful = helpful;
      flyspell = flyspell;
      org = org;
      org-appear = org-appear;
      org-fragtog = org-fragtog;
      org-modern = org-modern;
      doc-view = doc-view;
      nov = nov;
      bibtex = bibtex;
      biblio = biblio;
      citar = citar;
      elfeed = elfeed;
      elfeed-org = elfeed-org;
      org-web-tools = org-web-tools;
      emms = emms;
      openwith = openwith;
      denote = denote;
      denote-journal = denote-journal;
      denote-org = denote-org;
      denote-sequence = denote-sequence;
      consult = consult;
      consult-notes = consult-notes;
      citar-denote = citar-denote;
      denote-explore = denote-explore;
      olivetti = olivetti;
      vundo = vundo;
      dictionary = dictionary;
      writegood-mode = writegood-mode;
      titlecase = titlecase;
      lorem-ipsum = lorem-ipsum;
      ediff = ediff;
      fountain-mode = fountain-mode;
      markdown-mode = markdown-mode;
      ox-epub = ox-epub;
      ox-latex = ox-latex;
    }
  );

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
      extraPackages = epkgs: builtins.attrValues emacsPackages ++ cfg.extraPackages;
    };

    # Platform-specific system dependencies
    home.packages =
      commonPkgs
      ++ lib.optionals pkgs.stdenv.isLinux linuxPkgs
      ++ lib.optionals pkgs.stdenv.isDarwin darwinPkgs;
  };
}
