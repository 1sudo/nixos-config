# https://search.nixos.org/options

{ config, lib, pkgs, ... }:


{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      ./hardware-configuration.nix
      ./neovim/main.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    discord
    discordo
    tmux
    screen
    pavucontrol
    parsec-bin
    obs-studio
    webcord
    parsec-bin
    gnome.nautilus
    bitwarden
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  environment.variables.AMD_VULKAN_ICD = "RADV";

  environment.shellInit = ''
    source $HOME/.bashrc
  '';

  programs.bash = {
    shellAliases = {
      firefox="nohup firefox > /dev/null 2>&1 &";
      discord="nohup discord > /dev/null 2>&1 &";
      parsec="nohup parsecd > /dev/null 2>&1 &";
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      dmenu
      swaylock
      swayidle
      xwayland
      xwaylandvideobridge
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # copy/paste from stdin/stdout
      mako # notification system for sway
      kanshi
      wf-recorder
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig";
    wantedBy = [ "graphical-session.target" ];
    partOf = ["graphical-session.target" ];
    environment = { XDG_CONFIG_HOME="/home/zac/.conf"; };
    serviceConfig = {
      ExecStart = ''
      ${pkgs.kanshi}/bin/kanshi
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.displayManager.defaultSession = "sway";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.libinput.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

  fileSystems."/data0" = {
    device = "192.168.1.151:/mnt/user/data0";
    fsType = "nfs";
  };

  fileSystems."/emby1" = {
    device = "192.168.1.151:/mnt/user/emby1";
    fsType = "nfs";
  };

  users.users.zac = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/zac";
    createHome = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      terminator
    ];
  };
  
  # Do not edit
  system.stateVersion = "23.11"; 
}

