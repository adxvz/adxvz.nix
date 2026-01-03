{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.emacs;

  homeDir = config.home.homeDirectory;
  doomDir = "${homeDir}/.config/emacs";
  oldDir = "${homeDir}/.emacs.d";
  doomRepo = "https://github.com/doomemacs/doomemacs.git";

  # Emacs base package set
  emacsPkg = (pkgs.emacsPackagesFor pkgs.emacs-plus).emacsWithPackages (
    epkgs:
    with epkgs;
    [
      vterm
      treesit-grammars.with-all-grammars
    ]
    ++ lib.optionals cfg.org.enable [ org ]
  );

  # Haskell support packages
  haskellPkgs = cfg.haskellPackages or [ ];

  isDarwin = config.system.isDarwin or false;
in
{
  options.modules.emacs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Emacs configuration.";
    };

    doom.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Install and manage Doom Emacs automatically.";
    };

    org.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Org mode package in Emacs.";
    };

    haskellPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExample "[ pkgs.ghc pkgs.haskellPackages.haskellLanguageServer ]";
      description = ''
        Extra Haskell packages to install alongside Emacs.
        Useful for Haskell development environments in Doom Emacs.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        emacsPkg
        git
        ripgrep
        fd
        pandoc
        luajitPackages.luacheck
        luajitPackages.lua-lsp
        texlive.combined.scheme-full # provides latex, dvipng
        imagemagick # provides convert
        ghostscript # provides gs
        poppler # provides pdftotext
      ]
      ++ haskellPkgs;

    # Launchd only on Darwin
    home.activation.emacsLaunchd = mkIf isDarwin (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        launchd.enable = true
        launchd.agents.emacs = {
          enable = true;
          config = {
            ProgramArguments = [
              "${emacsPkg}/bin/emacs"
              "--daemon=default"
            ];
            RunAtLoad = true;
          };
        };
      ''
    );

    # --- Doom installation / upgrade ---
    home.activation.doomEmacs = mkIf cfg.doom.enable (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        set -e
        export PATH="${pkgs.git}/bin:${emacsPkg}/bin:$PATH"

        echo "→ Cleaning any old ~/.emacs.d..."
        rm -rf "${oldDir}"

        if [ ! -d "${doomDir}" ]; then
          echo "→ Cloning Doom Emacs from ${doomRepo}..."
          git clone --depth=1 "${doomRepo}" "${doomDir}"
          echo "→ Running initial doom install..."
          "${doomDir}/bin/doom" install --force || true
        else
          echo "→ Updating Doom Emacs..."
          git -C "${doomDir}" pull --ff-only || true
          echo "→ Syncing Doom Emacs..."
          "${doomDir}/bin/doom" sync || true
        fi
      ''
    );

    # --- Vanilla Emacs native-comp cache ---
    # Only when Doom is NOT enabled
    home.file."~/.emacs.d/eln-cache/.gitignore".text = lib.mkIf (!cfg.doom.enable) "*\n";
    home.file."~/.emacs.d/init.el".text = lib.mkIf (!cfg.doom.enable) ''
      (setq native-comp-eln-load-path (list "~/.emacs.d/eln-cache/"))
      (make-directory "~/.emacs.d/eln-cache/" t)
    '';
  };
}
