{
  pkgs,
  ...
}:

{

  users.users.adxvz = {
    isNormalUser = true;
    hashedPassword = "$6$AMF7.0t72oLFRYVq$MXNM.485TMsJZkJSo5wPZYZaRHVi9TvRt8yPrCx0tzwQ9z/xGNca.oSk9KZPYFTXA.9QZdGllkP.8.Q8fMaXi0";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.zsh;
  };

  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [
    vim
    mousepad
    git
    htop
  ];

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 3d";
    };
    flake = "/home/adxvz/Developer/adxvz.nix/";
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  boot.tmp.cleanOnBoot = true;

  time.timeZone = "Europe/London";

  services.xserver.enable = true;
  services.xserver.xkb.layout = "gb";

  programs.zsh.enable = true;

}
