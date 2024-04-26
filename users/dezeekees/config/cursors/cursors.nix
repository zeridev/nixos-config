{ pkgs, ... }:

{
  home.pointerCursor = {
    gtk.enable = true;
    name = "Posys Cursor";

    package = pkgs.stdenvNoCC.mkDerivation {
      name = "posys_cursor";

      src = pkgs.fetchFromGitHub {
        owner = "dezeekees";
        repo = "posy-improved-cursor-linux";
        rev = "master";
        sha256 = "sha256-ndxz0KEU18ZKbPK2vTtEWUkOB/KqA362ipJMjVEgzYQ=";
      };

      dontBuild = true;

      installPhase = ''
        mkdir -p $out/share/icons
        mv Posy_Cursor "$out/share/icons/Posy's Cursor"
      '';
    };

    size = 24;
    x11.enable = true;
  };
}