{
  pkgs,
  ...
}:

{

  modules.nix.enable = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
  };

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

  users = {
    users.adxvz = {
      isNormalUser = true;
      hashedPassword = "$6$AMF7.0t72oLFRYVq$MXNM.485TMsJZkJSo5wPZYZaRHVi9TvRt8yPrCx0tzwQ9z/xGNca.oSk9KZPYFTXA.9QZdGllkP.8.Q8fMaXi0";
    };
    mutableUsers = false;
  };

  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

}
