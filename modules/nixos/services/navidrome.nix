{ config, lib, flakeRoot, ... }:
let
  cfg = config.myServices.navidrome;
  navidromeEnvFile = "${flakeRoot}/secrets/navidrome-env.age";
in
{
  options.myServices.navidrome = {
    enable = lib.mkEnableOption "Enables navidrome";

    musicDir = lib.mkOption {
      description = "where the music is at";
    };
  };

  config = lib.mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      group = "music";
      environmentFile = config.age.secrets."navidrome-env".path;

      settings = { 
        MusicFolder = cfg.musicDir;
      };
    };

    age.secrets."navidrome-env".file = navidromeEnvFile;
  };
}