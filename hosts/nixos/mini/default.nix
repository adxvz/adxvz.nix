{
  ...
}:

{
  imports = [
    # Import hardware configuration (filesystem info, etc.)
    ./hardware-configuration-mini.nix
    ./disko.nix
  ];

  # Hostname
  networking.hostName = "mini";

  # Any mini-specific configuration
  # This could include:
  # - Network settings specific to mini
  # - Hardware-specific tweaks
  # - Storage configurations
  # etc.

  # Example: specific network configuration
  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "192.168.1.10";
      prefixLength = 24;
    }
  ];

  # Example: enable monitoring tools for lab
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      port = 9100;
    };
  };
}
