{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.ssh;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  options = {
    modules.ssh = {
      enable = mkEnableOption "Enable SSH agent and key management";

      keyDir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to a local directory containing SSH keys.";
      };

      keyRepo = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Git repository URL containing SSH keys.";
      };

      useKeychain = mkOption {
        type = types.bool;
        default = isDarwin;
        description = "Add SSH keys to Apple Keychain (macOS only).";
      };
    };
  };

  config = mkIf cfg.enable {

    ## --- Enable SSH program configuration
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        forwardAgent = true;
        controlMaster = "auto";
        controlPersist = "10m";
      };
      extraConfig = ''
        Host *
          AddKeysToAgent ${if isDarwin && cfg.useKeychain then "yes" else "no"}
          ${optionalString isDarwin "UseKeychain yes"}
          IdentityFile ~/.ssh/adxvz_ed25519
      '';
    };

    ## --- Ensure ~/.ssh exists and contains keys
    home.activation.setupSSH = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -e
      mkdir -p "$HOME/.ssh"
      chmod 700 "$HOME/.ssh"

      echo "🔑 Setting up SSH keys..."

      # If keyRepo is set, clone it
      ${optionalString (cfg.keyRepo != null) ''
        TMPDIR=$(mktemp -d)
        git clone --quiet --depth 1 "${cfg.keyRepo}" "$TMPDIR"
        cp -R "$TMPDIR"/* "$HOME/.ssh/"
        rm -rf "$TMPDIR"
      ''}

      # If keyDir is set, copy from it
      ${optionalString (cfg.keyDir != null) ''
        cp -R "${cfg.keyDir}"/* "$HOME/.ssh/"
      ''}

      # Fix permissions for private/public keys
      find "$HOME/.ssh" -type f -name "id_*" -exec chmod 600 {} \;
      find "$HOME/.ssh" -type f -name "*.pub" -exec chmod 644 {} \;

      echo "✅ SSH keys copied to ~/.ssh"
    '';

    ## --- Start ssh-agent automatically (both Linux + macOS)
    #    programs.ssh.startAgent = true;

    ## --- Darwin-specific setup (Apple Keychain)
    home.activation.sshAgentDarwin = mkIf isDarwin (
      lib.hm.dag.entryAfter [ "setupSSH" ] ''
        echo "🍎 Configuring SSH agent with Apple Keychain support..."
        for key in "$HOME"/.ssh/id_*; do
          if [ -f "$key" ] && [[ "$key" != *.pub ]]; then
            /usr/bin/ssh-add --apple-use-keychain "$key" || true
          fi
        done
      ''
    );

    ## --- Linux-specific setup (add keys manually to ssh-agent)
    home.activation.sshAgentLinux = mkIf (!isDarwin) (
      lib.hm.dag.entryAfter [ "setupSSH" ] ''
        echo "🐧 Adding SSH keys to ssh-agent..."
        eval "$(${pkgs.openssh}/bin/ssh-agent -s)" >/dev/null
        for key in "$HOME"/.ssh/id_*; do
          if [ -f "$key" ] && [[ "$key" != *.pub ]]; then
            ${pkgs.openssh}/bin/ssh-add "$key" || true
          fi
        done
      ''
    );
  };
}
