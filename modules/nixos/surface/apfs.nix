{ config, lib, pkgs, ... }:

with lib;

let
  apfsHelper = "${pkgs.apfs-fuse}/bin/apfs-fuse";
in
{
  options.hardware.apfs.autoMount = mkOption {
    type = types.bool;
    default = true;
    description = "Automatically mount any APFS drive using FUSE.";
  };

  config = mkIf config.hardware.apfs.autoMount {
    # Ensure FUSE3 is enabled
    boot.supportedFilesystems = [ "fuse" ];
    programs.fuse.userAllowOther = true;

    environment.systemPackages = with pkgs; [
      apfs-fuse
      fuse3
      util-linux
    ];

    # Create the systemd helper symlink mount.fuse.apfs
    systemd.tmpfiles.rules = [
      "L+ /run/current-system/sw/bin/mount.fuse.apfs - - - - ${apfsHelper}"
    ];

    # Optional: udisks2 integration for desktop auto-mount
    services.udisks2.enable = true;

    # Automatically create /media/apfs directory
    environment.etc."media/apfs".source = "/run/media"; # optional base path
  };
}
