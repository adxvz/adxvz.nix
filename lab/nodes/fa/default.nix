networking = {
  hostName = "fa";
  interfaces = {
    enp90s0.ipv4.addresses = [{ address = "10.10.110.7"; prefixLength = 28; }];
    enp1s0f0.ipv4.addresses = [{ address = "172.27.120.20"; prefixLength = 25; }];
    # ↑ Note: Changed interface from enp2s0f0np0 to enp1s0f0 (masters use different NICs)
  };
  # ... rest stays the same
};

# Add master-specific overrides
services.kubernetes = {
  apiserver.advertiseAddress = "172.27.120.20";
  kubelet.extraOpts = lib.mkForce ''
    --node-ip=172.27.120.20
    --cluster-dns=10.96.0.10
    --cluster-domain=cluster.local
    --fail-swap-on=false
  '';
};
