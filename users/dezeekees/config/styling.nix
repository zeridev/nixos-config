{ pkgs, ... }:
let 

  cursor_package = pkgs.stdenvNoCC.mkDerivation {
    name = "Posys Cursor";

    src = pkgs.fetchFromGitHub {
      owner = "dezeekees";
      repo = "posy-improved-cursor-linux";
      rev = "bd2bac08bf01e25846a6643dd30e2acffa9517d4";
      sha256 = "sha256-ndxz0KEU18ZKbPK2vTtEWUkOB/KqA362ipJMjVEgzYQ=";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/icons
      mv Posy_Cursor "$out/share/icons/Posys Cursor"
    '';

  };

  cursor_name = "Posys Cursor";
  cursor_size = 18;

in {

  home.pointerCursor = {
    gtk.enable = true;
    name = cursor_name;

    package = cursor_package;

    size = cursor_size;
    x11.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;

    cursorTheme = {
      name = cursor_name;
      package = cursor_package;
      size = cursor_size;
    };

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };
  
}