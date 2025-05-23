# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./kitty.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zac = {
    isNormalUser = true;
    description = "Zac";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  virtualisation.docker.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.hyprland.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    discord-canary
    helix
    curl
    go
    wget
    git
    vscode
    bitwarden-desktop
    parsec-bin
    unzip
    zip
    plasma-panel-colorizer
    protonup-qt
    htop
    alsa-utils
    gdb
    libreoffice
    obs-studio
    bottles
    meld
    gimp
    inkscape
    gtk3
    gtk4
    postman
    transmission_4-qt
    docker-compose
    element-desktop
    talosctl
    kubectl
    kubernetes-helm
    jq
    envsubst
    kubecolor
    git-lfs
    tree
    tmux
    tailscale
    vlc
    kubectl-cnpg
    wofi
    hyprpaper
    hyprwall
    hyprlock
    hypridle
    slack
    grim
    slurp
    wl-clipboard
    zls

    # Necessary for Godot
    dbus
    fontconfig
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXi
    xorg.libXext
    xorg.libXfixes
    libxkbcommon
    mesa
    libGL
    vulkan-loader
    wayland
    wayland-protocols
    freetype
    openssl
    libGLU
    alsa-lib
    zlib
    pulseaudio
  ];

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  services.transmission.settings = {
    download-dir = "${config.services.transmission.home}/Downloads";
  };

  # environment.sessionVariables = {
  #   LD_LIBRARY_PATH = lib.makeLibraryPath [
  #     pkgs.gtk3
  #     pkgs.pango
  #     pkgs.cairo
  #     pkgs.glib
  #     pkgs.alsa-lib
  #     pkgs.libpulseaudio
  #     "${pkgs.chromium}/lib"
  #   ];
  # };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "cuemu-web" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host all all all trust
    '';
  };

  programs.steam = {
    enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib  # libstdc++
    glibc

    # Needed for Godot
    libxkbcommon
    dbus
    mesa
    libGL
    vulkan-loader
    wayland
    wayland-protocols
    freetype
    openssl
    libGLU
    alsa-lib
    zlib
    fontconfig
    pulseaudio
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXi
    xorg.libXext
    xorg.libXfixes
  ];

  security.pam.loginLimits = [
    { domain = "*"; item = "nofile"; type = "-"; value = "65536"; }
    { domain = "*"; item = "memlock"; type = "-"; value = "65536"; }
  ];
  systemd.user.extraConfig = "DefaultLimitNOFILE=65536";
  systemd.extraConfig = "DefaultLimitNOFILE=65536";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
