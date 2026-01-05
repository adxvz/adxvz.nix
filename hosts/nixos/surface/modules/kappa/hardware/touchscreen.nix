{
  services.iptsd = {
    enable = true;
    config = {
      Touchscreen.DisableOnPalm = true;
      Touchscreen.DisableOnStylus = true;
    };
  };
}
