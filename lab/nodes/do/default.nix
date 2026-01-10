{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "do";
    useDHCP = false;

    interfaces = {
      eno1 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "10.10.110.1";
            prefixLength = 28;
          }
        ];
      };

      enp1s0f0 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "172.27.120.10";
            prefixLength = 25;
          }
        ];
      };
    };

    defaultGateway = {
      address = "10.10.110.14";
      interface = "eno1";
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  # Override Kubernetes settings with this node's specific IP
  services.kubernetes = {
    apiserver.advertiseAddress = "172.27.120.10";
    kubelet.extraOpts = lib.mkForce ''
      --node-ip=172.27.120.10
      --cluster-dns=10.96.0.10
      --cluster-domain=cluster.local
      --fail-swap-on=false
    '';
  };
}
