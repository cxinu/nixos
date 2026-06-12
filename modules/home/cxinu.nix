{ config, pkgs, inputs, ... }:

let
  caelestia = inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    withCli = true;
  };
  zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.username = "cxinu";
  home.homeDirectory = "/home/cxinu";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  #  env session variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  # no root required
  home.packages = with pkgs; [
    # dev
    gcc
    go
    python3
    micromamba
    cargo
    rustc

    btop
    direnv
    ripgrep
    fzf
    tree
    duf
    ncdu
    tmux
    fastfetch
    lazygit
    ranger
    caelestia
    zathura
    kitty
    vesktop
    zen-browser
    telegram-desktop
  ];

  # binary configs
  programs.firefox.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  home.stateVersion = "26.11";
}
