{ inputs, ... }:

{
  imports = [
    inputs.aagl.nixosModules.default
  ];

  programs.anime-game-launcher.enable = true;

  programs.steam.gamescopeSession.enable = true;
  programs.gamescope.enable = true;
}