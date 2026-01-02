{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.ghostty;
  homeDir = config.home.homeDirectory;
  configDir = "${homeDir}/.config/ghostty";
  dataDir = "${homeDir}/.local/share/ghostty";
in
{
  options.modules.ghostty = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Ghostty terminal server.";
    };

    shell = mkOption {
      type = types.str;
      default = "${pkgs.zsh}/bin/zsh";
      description = "Default shell used by Ghostty sessions.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.ghostty ];

    home.activation.ghosttyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            mkdir -p "${dataDir}"

            # Only generate config if it doesn't exist
            if [ ! -f "${configDir}/ghostty.toml" ]; then
              mkdir -p "${configDir}"
              cat > "${configDir}/ghostty.toml" <<EOF
      # Ghostty default configuration
      shell = "${cfg.shell}"
      data-dir = "${dataDir}"
      EOF
            fi
    '';
  };
}
