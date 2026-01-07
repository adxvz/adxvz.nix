{
  pkgs,
  ...
}:

{
  imports = [
    ./disk.nix
    ./nh.nix
    ./timeZone.nix
  ];

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

  services.xserver.enable = true;
  services.xserver.xkb.layout = "gb";

  programs.zsh.enable = true;

}
