{

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  boot.tmp.cleanOnBoot = true;

}
