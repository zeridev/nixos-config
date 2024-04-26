{ inputs, ... }:

{
  imports = [
    inputs.aagl
  ];

  programs.anime-game-launcher.enable = true;
}