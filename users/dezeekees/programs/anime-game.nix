{ ... }:

let
  aagl = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{
  home.packages = [
    aagl.anime-game-launcher
    # aagl.anime-borb-launcher
    # aagl.honkers-railway-launcher
    # aagl.honkers-launcher
  ];
}