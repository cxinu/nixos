{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
    lutris
    heroic
    wineWow64Packages.stagingFull
    winetricks
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  programs.gpu-screen-recorder.enable = true;
}
