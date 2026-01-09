{
  ...
}:

{
  # Kubernetes storage node configuration

  # Enable required services for k8s storage
  services.kubernetes = {
    roles = [ "storage" ];
    storageAddress = "storage.local";
    easyCerts = true;

    apiserver = {
      enable = true;
      securePort = 6443;
    };

    controllerManager.enable = true;
    scheduler.enable = true;

    addons.dns.enable = true;
  };

  # Enable etcd for cluster state
  services.etcd = {
    enable = true;
    listenClientUrls = [ "https://0.0.0.0:2379" ];
  };

  # Firewall rules for storage node
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      6443 # Kubernetes API
      2379 # etcd client
      2380 # etcd peer
      10250 # Kubelet
      10251 # kube-scheduler
      10252 # kube-controller-manager
    ];
  };

  # System resources for storage
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
  };
}
