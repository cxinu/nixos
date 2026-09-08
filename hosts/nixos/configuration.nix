{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/gaming.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # grant memory access they say, but to whom?
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 0;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";
  hardware.opentabletdriver.enable = true;

  # nix daemon
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    curl

    cairo
    pango
    gtk3
    glib
    glib-networking
    gdk-pixbuf
    atk
    webkitgtk_4_1
    libayatana-appindicator
    openssl
    dbus
  ];

  users.users.cxinu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    # base packages
    git
    file
    wget
    curl
    clang
    neovim
    obs-studio
    libresplit
    lm_sensors
    openssl
    docker
    pavucontrol
    gsettings-desktop-schemas

    # odin/raylib
    pkg-config
    raylib
    wayland
    libxkbcommon
    libGL
    libX11
    libXcursor
    libXrandr
    libXinerama
    libXi
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  system.stateVersion = "26.05";
}
