{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

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

  # audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.libinput.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  users.users.cxinu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  # nvidia
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # base packages
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    neovim
  ];

  system.stateVersion = "26.11";
}
