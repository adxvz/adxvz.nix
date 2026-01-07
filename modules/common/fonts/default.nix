{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.fonts;

  # Standard fonts
  fontList = [
    pkgs.maple-mono.NF
    pkgs.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.victor-mono
    pkgs.nerd-fonts.symbols-only
  ];

  # Directory inside the flake containing custom fonts
  customFontsDir = ./bible;

  # List of custom font paths
  customFonts = builtins.attrValues (builtins.readDir customFontsDir);

in
{
  options.modules.fonts = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable installation of additional fonts, including custom ones inside the flake.";
    };
  };

  config = mkIf cfg.enable ({

    # Standard fonts for all platforms
    fonts.packages = fontList;

    # Linux/NixOS: add custom fonts declaratively
    fonts.fonts = pkgs.lib.mkIf pkgs.stdenv.isLinux customFonts;

    # Darwin: install fonts using darwin.mkFont
    environment.systemPackages = pkgs.lib.mkIf pkgs.stdenv.isDarwin (
      map (
        fontPath:
        pkgs.runCommand (builtins.baseNameOf fontPath) { } ''
          mkdir -p $out
          cp -R ${customFontsDir}/${fontPath}/* $out/
        ''
      ) customFonts
    );

  });
}
