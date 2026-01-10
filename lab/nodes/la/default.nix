# ==============================================================================
# WORKER NODE: la
# ==============================================================================
# lab/nodes/la/default.nix
{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    # Note: worker.nix is auto-loaded via role="worker" in flake.nix
  ];

  networking = {
    hostName = "la";

    useDHCP = false;

    interfaces = {
      # Management interface - 2.5gb
      enp90s0 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "10.10.110.9";
            prefixLength = 28;
          }
        ];
      };

      # Cluster interface - 10gb
      enp2s0f0np0 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "172.27.120.22";
            prefixLength = 25;
          }
        ];
      };
    };

    defaultGateway = {
      address = "172.27.120.254";
      interface = "enp2s0f0np0";
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  services.kubernetes.kubelet.extraOpts = lib.mkForce ''
    --node-ip=172.27.120.22
    --cluster-dns=10.96.0.10
    --cluster-domain=cluster.local
    --fail-swap-on=false
    --root-dir=/var/lib/kubelet
  '';
}
