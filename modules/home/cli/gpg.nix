{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.gpg;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  options = {
    modules.gpg = {
      enable = lib.mkEnableOption "Enable GPG key management";

      keyDir = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Local folder containing GPG keys to import.";
      };

      keyRepo = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Git repo containing GPG keys.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure gpg and gpgconf are available
    programs.gpg.enable = true;

    home.activation.gpgKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -e
      mkdir -p "$HOME/.gnupg"

      echo "🔐 Importing GPG keys..."

      # Clone repo if provided
      ${lib.optionalString (cfg.keyRepo != null) ''
        TMPDIR=$(mktemp -d)
        git clone --quiet --depth 1 "${cfg.keyRepo}" "$TMPDIR"
        for key in "$TMPDIR"/*.asc "$TMPDIR"/*.gpg; do
          [ -f "$key" ] && gpg --import "$key" || true
        done
        rm -rf "$TMPDIR"
      ''}

      # Import from local directory
      ${lib.optionalString (cfg.keyDir != null) ''
        for key in ${cfg.keyDir}/*.asc ${cfg.keyDir}/*.gpg; do
          if [ -f "$key" ]; then
            gpg --import "$key" || true
          fi
        done
      ''}

      echo "✅ GPG keys imported."

      # Fix permissions (skip chmod on macOS)
      if ${if isDarwin then "false" else "true"}; then
        chmod 700 "$HOME/.gnupg" || true
        chmod 600 "$HOME/.gnupg"/* || true
      else
        echo "⚠️ Skipping chmod on macOS (protected by SIP)"
      fi

      # Reload gpg-agent if available
      if command -v gpgconf >/dev/null 2>&1; then
        gpgconf --kill gpg-agent || true
        gpgconf --launch gpg-agent || true
      fi
    '';
  };
}
