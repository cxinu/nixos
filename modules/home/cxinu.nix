{ config, pkgs, inputs, ... }:

let
  caelestia = inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    withCli = true;
  };
  zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  home.username = "cxinu";
  home.homeDirectory = "/home/cxinu";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
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

    # terminal
    ripgrep
    fzf
    tree
    duf
    ncdu
    tmux
    fastfetch
    lazygit
    ranger
    bluetui
    nvtopPackages.full
    github-cli

    # gui
    caelestia
    kitty
    thunar
    hyprshot
    vesktop
    zen-browser
    telegram-desktop
    zathura
    proton-vpn
  ];

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "cxinu";
        email = "cxinu.main@protonmail.com";
      };
      init.defaultBranch = "master";
      gpg = {
        format = "ssh";
      };
    };
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZi97nUZxJnEYl5ZgyxFOW5DwDW4RN/ZXMG3O8MgkzD cxinu.main@protonmail.com";
      signByDefault = true;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        addKeysToAgent = "yes";
      };
    };
  };

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
      beautifulLyrics
    ];
    enabledCustomApps = with spicePkgs.apps; [
      newReleases
      lyricsPlus
    ];
    theme = spicePkgs.themes.defaultDynamic;
    colorScheme = "Dark-Base";
  };

  programs.btop = {
    enable = true;
    package = pkgs.btop.override {
      cudaSupport = true;
      rocmSupport = true;
    };
    settings = {
      shown_boxes = "cpu mem net proc gpu0";
    };
  };

  programs.mpv.enable = true;

  home.stateVersion = "26.05";
}
