{
  pkgs,
  lib,
  ...
}:
{
  # User Configuration
  users = {
    users.adxvz = {
      isNormalUser = true;
      hashedPassword = "$6$AMF7.0t72oLFRYVq$MXNM.485TMsJZkJSo5wPZYZaRHVi9TvRt8yPrCx0tzwQ9z/xGNca.oSk9KZPYFTXA.9QZdGllkP.8.Q8fMaXi0";
      description = "adxvz";
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
      ];
    };
    mutableUsers = false;
  };

  # Enable custom nix module
  modules.nix.enable = lib.mkDefault true;

  # Boot Configuration
  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
    tmp.cleanOnBoot = true;
  };

  # Services
  services = {
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };
  };

  # Timezone
  time.timeZone = "Europe/London";

  # Base system packages
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Networking
  networking.networkmanager.enable = lib.mkDefault true;

  # Set system state version
  system.stateVersion = lib.mkDefault "25.11";
}
