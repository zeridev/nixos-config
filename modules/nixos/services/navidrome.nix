{ config, lib ,... }:
let
  cfg = config.myServices.navidrome;
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
      group = "slskd";

      settings = { 
        MusicFolder = cfg.musicDir;
      };
    };
  };
}