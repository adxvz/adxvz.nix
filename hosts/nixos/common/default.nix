{
  pkgs,
  ...
}:

{
  imports = [ ];

  users.users.adxvz = {
    isNormalUser = true;
    password = "Testing123!";
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
