{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # ./hardware-configuration.nix
    ../disko.nix
  ];

  networking = {
    hostName = "ti";
    useDHCP = false;

    interfaces = {
      enp1s0f0 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "172.27.120.17";
            prefixLength = 25;
          }
        ];
      };

      # Optional: Second 10gb interface for bonding
      # Uncomment if enp1s0f1 is working and you want bonding
      enp1s0f1 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "172.27.120.18";
            prefixLength = 25;
          }
        ];
      };
    };

    # Default gateway (single interface)
    # defaultGateway = {
    #   address = "172.27.120.170";
    #   interface = "enp1s0f0";
    # };

    # If using bonding, uncomment this and comment out the above gateway
    defaultGateway = {
      address = "172.27.120.254";
      interface = "bond0";
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  services.kubernetes.kubelet.extraOpts = lib.mkForce ''
    --node-ip=172.27.120.30
    --cluster-dns=10.96.0.10
    --cluster-domain=cluster.local
    --fail-swap-on=false
    --root-dir=/var/lib/kubelet
  '';

  # Uncomment to enable bonding for 20gb throughput
  networking.bonds.bond0 = {
    interfaces = [
      "enp1s0f0"
      "enp1s0f1"
    ];
    driverOptions = {
      mode = "802.3ad";
      miimon = "100";
      lacp_rate = "fast";
      xmit_hash_policy = "layer3+4";
    };
  };

  # If bonding is enabled, update flannel interface
  services.kubernetes.flannel.iface = lib.mkIf (config.networking.bonds ? bond0) "bond0";
}
