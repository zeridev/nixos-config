{ lib, config, flakeRoot, ... }:

let
  cfg = config.myServices.docker.explo;
  dockerCfg = config.myServices.docker;
  exploEnvFile = "${flakeRoot}/secrets/explo-env.age";
in

{
  options.myServices.docker.explo = {
    enable = lib.mkEnableOption "Enables the explo web container";
  };

  config = lib.mkIf (dockerCfg.enable && cfg.enable) {
    virtualisation.oci-containers.containers.explo = {
      image = "ghcr.io/lumepart/explo:latest";

      autoStart = true;

      environment = {
        TZ = "Europe/Amsterdam";

        WEEKLY_EXPLORATION_SCHEDULE = "15 00 * * 2";
        WEEKLY_EXPLORATION_FLAGS = "";
      };

      volumes = [
        "${config.age.secrets."explo-env".path}:/opt/explo/.env:ro"
        "/mnt/other1/music/explo:/data:rw"
        "/mnt/other1/soulseek/downloads:/slskd:rw"
        
        # "/my/playlists:/my/playlists:rw"
        # "/path/to/cookies.txt:/opt/explo/cookies.txt:ro"
      ];
    };

    age.secrets."explo-env".file = exploEnvFile;
  };
}