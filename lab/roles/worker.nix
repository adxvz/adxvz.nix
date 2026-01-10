{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Kubernetes Worker Node Configuration
  # This configuration applies to ANY node with role="worker"
  # Host-specific settings (hostname, IPs) are in lab/nodes/<hostname>/default.nix

  services.kubernetes = {
    roles = [ "node" ];
    masterAddress = "172.27.120.10"; # Primary master (do)

    kubelet = {
      enable = true;

      # node-ip is set per-host in node config
      extraOpts = ''
        --cluster-dns=10.96.0.10
        --cluster-domain=cluster.local
        --fail-swap-on=false
        --root-dir=/var/lib/kubelet
      '';

      # Use btrfs RAID1 mount for pods/containers
      kubeconfig = {
        server = "https://172.27.120.10:6443";
        caFile = "/var/lib/kubernetes/ca.pem";
        certFile = "/var/lib/kubernetes/kubelet.pem";
        keyFile = "/var/lib/kubernetes/kubelet-key.pem";
      };
    };

    proxy = {
      enable = true;

      extraOpts = ''
        --cluster-cidr=172.27.120.1/24
      '';
    };

    # Flannel CNI configuration
    flannel = {
      enable = true;
      network = "172.27.120.0/24";
      iface = "enp2s0f0np0"; # 10gb interface for workers
    };
  };

  # Enable and configure container runtime (containerd)
  virtualisation.containerd = {
    enable = true;
    settings = {
      version = 2;
      plugins."io.containerd.grpc.v1.cri" = {
        cni = {
          bin_dir = "/opt/cni/bin";
          conf_dir = "/etc/cni/net.d";
        };
        containerd = {
          runtimes = {
            runc = {
              runtime_type = "io.containerd.runc.v2";
              options = {
                SystemdCgroup = true;
              };
            };
          };
        };
        sandbox_image = "pause:3.9";
      };
    };
  };

  # BTRFS RAID1 configuration for worker node storage
  # This uses the two 1TB NVMe drives in a RAID1 mirror
  fileSystems."/var/lib/kubelet" = {
    device = "/dev/disk/by-label/k8s-storage";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "space_cache=v2"
      "autodefrag"
    ];
  };

  # BTRFS RAID1 setup
  # Auto-creates the BTRFS array on first boot using the 2x 1TB NVMe drives
  systemd.services.setup-k8s-storage = {
    description = "Setup Kubernetes Storage RAID1";
    wantedBy = [ "multi-user.target" ];
    before = [ "var-lib-kubelet.mount" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      # Check if the BTRFS filesystem already exists
      if ! ${pkgs.util-linux}/bin/blkid -L k8s-storage > /dev/null 2>&1; then
        echo "Creating BTRFS RAID1 for Kubernetes storage..."
        ${pkgs.btrfs-progs}/bin/mkfs.btrfs \
          -m raid1 \
          -d raid1 \
          -L k8s-storage \
          -f \
          /dev/nvme1n1 \
          /dev/nvme2n1
      else
        echo "Kubernetes storage filesystem already exists"
      fi
    '';
  };

  # Networking configuration
  networking = {
    firewall = {
      enable = true;

      # Allow Kubernetes worker ports on 10gb network
      allowedTCPPorts = [
        10250 # Kubelet API
        30000 # NodePort Services start
        32767 # NodePort Services end
        22 # SSH on management interface
      ];

      # Flannel VXLAN
      allowedUDPPorts = [
        8285 # Flannel UDP
        8472 # Flannel VXLAN
      ];

      # Trust the 10gb cluster network and flannel
      trustedInterfaces = [
        "enp2s0f0np0"
        "flannel.1"
      ];
    };

    # Enable IP forwarding
    enableIPv6 = false;
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
    # Increase for Longhorn
    "vm.max_map_count" = 262144;
  };

  # Load required kernel modules
  boot.kernelModules = [
    "br_netfilter"
    "overlay"
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    kubernetes
    kubectl
    cri-tools
    btrfs-progs
    flannel
  ];

  # Ensure services start in correct order
  systemd.services.kubelet = {
    after = [
      "network-online.target"
      "containerd.service"
      "var-lib-kubelet.mount"
    ];
    wants = [ "network-online.target" ];
  };

  # Disable swap (Kubernetes requirement)
  swapDevices = [ ];

  # Enable Longhorn prerequisites
  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}-initiator";
  };

  # Longhorn requires NFSv4
  services.nfs.server.enable = false;
}
