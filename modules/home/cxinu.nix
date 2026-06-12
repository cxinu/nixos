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

  #  env session variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
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
    duf
    ncdu
    kitty
    lazygit
    ranger
    tmux
    tree
    caelestia
    zathura
    vesktop
    zen-browser
  ];

  # binary configs
  programs.firefox.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  home.stateVersion = "26.11";
}
