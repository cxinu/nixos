{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/gaming.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  # grant memory access they say, but to whom?
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 0;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";
  hardware.opentabletdriver.enable = true;
  hardware.graphics.enable = true;

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

    nss
    nspr
    gtk3
    cups
    expat

    dbus
    atk
    at-spi2-core
    pango
    cairo
    mesa
    libgbm
    alsa-lib


    cairo
    pango
    glib
    gdk-pixbuf
    atk
    openssl
    dbus

    libX11
    libXcursor
    libXrandr
    libXinerama
    libXi
    libxcb
    libXcomposite
    libXdamage
    libXext
    libXfixes

    libGL
    libglvnd
    wayland
    libxkbcommon
    alsa-lib
    libpulseaudio
  ];

  environment.systemPackages = with pkgs; [
    # base packages
    git
    git-lfs
    file
    exiftool
    wget
    curl
    clang
    neovim
    libresplit
    lm_sensors
    openssl
    gpu-screen-recorder
    pavucontrol
    gsettings-desktop-schemas

    # odin/raylib
    pkg-config
    raylib
    wayland
    libxkbcommon
    libGL
    libglvnd
    libX11
    libXcursor
    libXrandr
    libXinerama
    libXi

    # ffmpeg
    ffmpeg
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  users.users.cxinu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  system.stateVersion = "26.05";
}
