{ pkgs, ... }:

{
  imports = [
    # ./hardware-configuration.nix
    ./disko-config.nix
    ../minimal.nix
  ];

  # Networking
  networking.hostName = "mini";

  # Internationalization
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable X11 with i3 window manager (lightweight, keyboard-driven)
  services.xserver = {
    enable = true;

    # Display manager
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
    };

    # Window manager
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu # Application launcher
        i3status # Status bar
        i3lock # Screen locker
        i3blocks # Alternative status bar
      ];
    };
  };

  # Audio (for system alerts and notifications)
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    # === Terminal & Editor ===
    ghostty # Modern GPU-accelerated terminal emulator
    neovim # Modal text editor

    # === Web Browsers ===
    firefox # Primary browser for documentation/dashboards
    chromium # Alternative browser for testing

    # === Kubernetes Management ===
    kubectl # Official Kubernetes CLI
    kubectx # Quickly switch between Kubernetes contexts
    kubens # Quickly switch between Kubernetes namespaces
    k9s # Terminal UI for Kubernetes - interactive cluster management
    kubernetes-helm # Kubernetes package manager
    helmfile # Declarative spec for deploying Helm charts
    kustomize # Template-free Kubernetes configuration customization
    stern # Multi-pod and multi-container log tailing
    kubecolor # Colorizes kubectl output for readability
    kube-capacity # Shows resource requests/limits/usage across cluster
    popeye # Kubernetes cluster sanitizer - scans for issues
    velero # Kubernetes backup and disaster recovery
    argocd # Declarative GitOps continuous delivery

    # === Docker & Container Management ===
    docker # Container runtime
    docker-compose # Multi-container application orchestration
    lazydocker # Terminal UI for Docker - manage containers/images/volumes
    dive # Inspect and analyze Docker image layers
    ctop # Top-like interface for container metrics

    # === Monitoring & Observability ===
    btop # Resource monitor with graphs (CPU, RAM, disk, network)
    nethogs # Per-process network bandwidth monitor
    iotop # Disk I/O monitor by process

    # === Network Tools ===
    nmap # Network discovery and security auditing
    tcpdump # Network packet analyzer
    wireshark # GUI network protocol analyzer
    dig # DNS lookup utility
    curl # Transfer data from/to servers

    # === Ventoy & USB Tools ===
    ventoy-full # Create multiboot USB drives
    pv # Monitor progress of data through pipes
    ddrescue # Data recovery and disk imaging tool

    # === File Management ===
    ranger # Terminal file manager with vi bindings
    tree # Display directory structure

    # === Version Control ===
    gh # GitHub CLI for repo management

    # === Shell Enhancement ===
    tmux # Terminal multiplexer - multiple sessions in one terminal
    fzf # Fuzzy finder for files/history/processes
    ripgrep # Fast recursive grep alternative
    fd # Fast and user-friendly find alternative
    bat # Cat with syntax highlighting and git integration
    jq # JSON processor and formatter
    yq-go # YAML/JSON/XML processor

    # === Security & Secrets ===
    openssh # SSH client and server
    gnupg # GPG encryption
    age # Modern file encryption tool
    sops # Encrypted secrets management for Git

    # === System Utilities ===
    htop # Interactive process viewer
    killall # Kill processes by name
    lsof # List open files and network connections
    ncdu # Disk usage analyzer with ncurses interface
  ];

  # Enable Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true; # Automatically cleanup unused Docker resources
      dates = "weekly";
    };
  };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # SSH
    # Add other ports as needed for monitoring dashboards
  };

  # Performance tuning for monitoring workloads
  boot.kernel.sysctl = {
    "vm.swappiness" = 10; # Prefer RAM over swap
    "fs.inotify.max_user_watches" = 524288; # Increase file watch limit for development
  };

  # System state version
  system.stateVersion = "25.11";
}
