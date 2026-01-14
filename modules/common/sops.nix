{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;

let
  cfg = config.modules.sops;
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.modules.sops = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable sops-nix secrets management";
    };

    defaultSopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Default sops file to use for secrets.
        Example: /etc/nixos/secrets/secrets.yaml
      '';
    };

    age = {
      keyFile = mkOption {
        type = types.str;
        default =
          if isDarwin then
            "/var/root/Library/Application Support/sops/age/keys.txt"
          else
            "/var/lib/sops-nix/key.txt";
        description = "Path to age key file";
      };

      sshKeyPaths = mkOption {
        type = types.listOf types.str;
        default = if isDarwin then [ ] else [ "/etc/ssh/ssh_host_ed25519_key" ];
        description = "List of SSH host key paths to derive age keys from";
      };

      generateKey = mkOption {
        type = types.bool;
        default = isLinux;
        description = "Generate age key if it doesn't exist (NixOS only)";
      };
    };

    secrets = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            owner = mkOption {
              type = types.str;
              default = "root";
              description = "Owner of the secret file";
            };

            group = mkOption {
              type = types.str;
              default = if isDarwin then "wheel" else "root";
              description = "Group of the secret file";
            };

            mode = mkOption {
              type = types.str;
              default = "0400";
              description = "File permissions mode";
            };

            path = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Path where the secret will be stored";
            };

            sopsFile = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = "Sops file containing this secret (overrides default)";
            };

            restartUnits = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = "List of systemd/launchd units to restart when secret changes";
            };
          };
        }
      );
      default = { };
      description = ''
        Attribute set of secrets to manage at system level.
        Each secret can have its own owner, group, mode, path, and sopsFile.
      '';
      example = literalExpression ''
        {
          "wireguard/private_key" = {
            owner = "systemd-network";
            group = "systemd-network";
            mode = "0440";
            restartUnits = [ "wireguard-wg0.service" ];
          };
          "certificates/ssl_cert" = {
            owner = "nginx";
            group = "nginx";
            mode = "0440";
            restartUnits = [ "nginx.service" ];
          };
        }
      '';
    };

    templates = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            content = mkOption {
              type = types.str;
              description = "Template content with secret placeholders";
            };

            owner = mkOption {
              type = types.str;
              default = "root";
              description = "Owner of the template file";
            };

            group = mkOption {
              type = types.str;
              default = if isDarwin then "wheel" else "root";
              description = "Group of the template file";
            };

            mode = mkOption {
              type = types.str;
              default = "0400";
              description = "File permissions mode";
            };

            path = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Path where the template will be rendered";
            };
          };
        }
      );
      default = { };
      description = ''
        Attribute set of templates that can reference secrets.
        Useful for configuration files that need multiple secrets.
      '';
      example = literalExpression ''
        {
          "wg0.conf" = {
            content = '''
              [Interface]
              PrivateKey = ''${config.sops.placeholder."wireguard/private_key"}
              Address = 10.0.0.1/24
            ''';
            owner = "systemd-network";
            group = "systemd-network";
            mode = "0440";
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    sops = {
      age.keyFile = cfg.age.keyFile;
      age.sshKeyPaths = cfg.age.sshKeyPaths;
      defaultSopsFile = mkIf (cfg.defaultSopsFile != null) cfg.defaultSopsFile;

      secrets = mapAttrs (name: secretCfg: {
        owner = secretCfg.owner;
        group = secretCfg.group;
        mode = secretCfg.mode;
        path = mkIf (secretCfg.path != null) secretCfg.path;
        sopsFile = mkIf (secretCfg.sopsFile != null) secretCfg.sopsFile;
        restartUnits = secretCfg.restartUnits;
      }) cfg.secrets;

      templates = mapAttrs (name: tmplCfg: {
        content = tmplCfg.content;
        owner = tmplCfg.owner;
        group = tmplCfg.group;
        mode = tmplCfg.mode;
        path = mkIf (tmplCfg.path != null) tmplCfg.path;
      }) cfg.templates;
    }
    // optionalAttrs isLinux {
      age.generateKey = cfg.age.generateKey;
    };

    # Install sops package
    environment.systemPackages = [ pkgs.sops ];
  };
}
