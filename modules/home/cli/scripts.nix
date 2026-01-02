{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  defaultScriptsDir = ./../../../bin/scripts;

  defaultRuntimeInputs = with pkgs; [
    git
    php
    phpPackages.composer
    findutils
    coreutils
    openssh
  ];

  cfg = config.modules.scripts;

in
{
  options.modules.scripts = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable installing scripts from a folder as global commands (symlinked).";
    };

    folder = mkOption {
      type = types.path;
      default = defaultScriptsDir;
      description = "Folder containing scripts to install.";
    };

    extraRuntimeInputs = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra packages/tools to make available in all scripts.";
    };
  };

  config = mkIf cfg.enable {

    # Add default + extra tools to PATH
    home.sessionVariables.PATH =
      let
        tools = defaultRuntimeInputs ++ cfg.extraRuntimeInputs;
      in
      "${lib.makeBinPath tools}:$PATH";

    # Symlink all scripts into ~/.local/bin
    home.activation = lib.mkAfter ''
      mkdir -p $HOME/.local/bin
      for script in ${toString cfg.folder}/*; do
        target="$HOME/.local/bin/$(basename $script)"
        ln -sf "$script" "$target"
        chmod +x "$script"
      done
    '';
  };
}
