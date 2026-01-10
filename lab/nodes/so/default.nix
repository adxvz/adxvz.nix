{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    #  ./hardware-configuration.nix
  ];

  networking = {
    hostName = "so"; # ← Change this
    useDHCP = false;

    interfaces = {
      enp90s0 = {
        # ← Different interface name (worker)
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "10.10.110.5"; # ← Change this
            prefixLength = 28;
          }
        ];
      };

      enp2s0f0np0 = {
        # ← Different interface name (worker)
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "172.27.120.15"; # ← Change this
            prefixLength = 25;
          }
        ];
      };
    };

    defaultGateway = {
      address = "172.27.120.254"; # ← Different gateway (workers)
      interface = "enp2s0f0np0"; # ← Uses cluster interface
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  # Workers don't have apiserver, only kubelet config
  services.kubernetes.kubelet.extraOpts = lib.mkForce ''
    --node-ip=172.27.120.20  # ← Change this
    --cluster-dns=10.96.0.10
    --cluster-domain=cluster.local
    --fail-swap-on=false
    --root-dir=/var/lib/kubelet
  '';
}
