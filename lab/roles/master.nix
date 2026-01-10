{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Longhorn Storage Server Configuration
  # This configuration applies to ANY node with role="storage"
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
    #   flannel = {
    #     enable = true;
    #     network = "172.27.120.0/24";
    #     iface = "enp1s0f0"; # 10gb interface (primary)
    #   };
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
      };
    };
  };

  # BTRFS RAID10 configuration for Longhorn storage pool
  # Using 6x 512GB SSDs in RAID10 configuration
  fileSystems."/var/lib/longhorn" = {
    device = "/dev/disk/by-label/longhorn-storage";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "space_cache=v2"
      "autodefrag"
    ];
  };

  # Setup Longhorn storage pool
  # Using RAID10 for better performance and redundancy with 6 drives
  # RAID10 gives you 3x 512GB = ~1.5TB usable space with redundancy
  systemd.services.setup-longhorn-storage = {
    description = "Setup Longhorn Storage Pool";
    wantedBy = [ "multi-user.target" ];
    before = [ "var-lib-longhorn.mount" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      # Check if the BTRFS filesystem already exists
      if ! ${pkgs.util-linux}/bin/blkid -L longhorn-storage > /dev/null 2>&1; then
        echo "Creating BTRFS RAID10 for Longhorn storage..."

        # RAID10 requires at least 4 devices
        # With 6x 512GB drives, this gives ~1.5TB usable
        ${pkgs.btrfs-progs}/bin/mkfs.btrfs \
          -m raid10 \
          -d raid10 \
          -L longhorn-storage \
          -f \
          /dev/sda \
          /dev/sdb \
          /dev/sdc \
          /dev/sdd \
          /dev/sde \
          /dev/sdf

        echo "Longhorn storage pool created successfully"
      else
        echo "Longhorn storage pool already exists"
      fi
    '';
  };

  # NFS server for legacy access (optional, if needed)
  # Longhorn will handle storage provisioning via CSI
  services.nfs.server = {
    enable = false; # Disabled by default, Longhorn uses iSCSI
    exports = ''
      /var/lib/longhorn 172.27.120.0/24(rw,sync,no_subtree_check,no_root_squash)
    '';
  };

  # Networking configuration
  networking = {
    firewall = {
      enable = true;

      # Allow Kubernetes and storage-related ports
      allowedTCPPorts = [
        10250 # Kubelet API
        30000 # NodePort Services start
        32767 # NodePort Services end
        2049 # NFS (if enabled)
        3260 # iSCSI for Longhorn
        9500 # Longhorn manager
        9501 # Longhorn conversion webhook
        9502 # Longhorn admission webhook
        22 # SSH
      ];

      # Flannel VXLAN
      allowedUDPPorts = [
        8285 # Flannel UDP
        8472 # Flannel VXLAN
      ];

      # Trust cluster network
      trustedInterfaces = [
        "enp1s0f0"
        "flannel.1"
      ];
    };

    # Enable IP forwarding
    enableIPv6 = false;

    # Optional: Bond the two 10gb interfaces for 20gb throughput
    # This requires both enp1s0f0 and enp1s0f1 to be working
    # Uncomment this section if you want to enable bonding
    # bonds = {
    #   bond0 = {
    #     interfaces = [ "enp1s0f0" "enp1s0f1" ];
    #     driverOptions = {
    #       mode = "802.3ad"; # LACP
    #       miimon = "100";
    #       lacp_rate = "fast";
    #       xmit_hash_policy = "layer3+4";
    #     };
    #   };
    # };
  };

  # If using bonding, update flannel to use bond0
  # services.kubernetes.flannel.iface = lib.mkIf (config.networking.bonds ? bond0) "bond0";

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
    # "net.bridge.bridge-nf-call-ip6tables" = 1;
    # Increase for Longhorn
    "vm.max_map_count" = 262144;
    "fs.inotify.max_user_instances" = 524288;
  };

  # Load required kernel modules
  boot.kernelModules = [
    "br_netfilter"
    "overlay"
    "iscsi_tcp" # For Longhorn iSCSI
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    kubernetes
    kubectl
    cri-tools
    btrfs-progs
    nfs-utils
    openiscsi
    util-linux
    flannel
  ];

  # Enable iSCSI for Longhorn
  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}-initiator";
  };

  # Ensure services start in correct order
  systemd.services.kubelet = {
    after = [
      "network-online.target"
      "containerd.service"
      "var-lib-longhorn.mount"
      "iscsid.service"
    ];
    wants = [ "network-online.target" ];
  };

  # Disable swap
  swapDevices = [ ];

  # Note: After node joins cluster, label it for Longhorn:
  # kubectl label nodes <hostname> node.longhorn.io/create-default-disk=true
}
