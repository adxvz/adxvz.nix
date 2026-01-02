{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.nushell;
in
{
  options.modules.nushell = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Nushell integration for Home Manager.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra Nushell initialization code to append to config.nu.";
    };
  };

  config = mkIf cfg.enable {
    # Enable shell integration
    home.shell.enableNushellIntegration = true;

    # Ensure Nushell is installed
    home.packages = [ pkgs.nushell ];

    # Create default config.nu with optional extra initialization
    home.file.".config/nushell/config.nu".text = ''
      # Default prompt
      let-env PROMPT = "(configurable) > "

      # Add common user paths
      let-env PATH = ($env.PATH | prepend $HOME/bin | prepend $HOME/.local/bin)

      # History file location
      let-env HISTORY_FILE = "$HOME/.config/nushell/history.txt"

      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix
    '';
  };
}
