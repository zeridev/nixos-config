{ config, lib, ... }:

let 
  cfg = config.myServices.docker.picard;
  dockerCfg = config.myServices.docker;
in

{
  options.myServices.docker.picard = {
    enable = lib.mkEnableOption "Enables the picard web container";
  };

  config = lib.mkIf (dockerCfg.enable && cfg.enable) {
    virtualisation.oci-containers.containers.picard = {
      image = "aandree5/picard-web:latest";
      ports = [ "5000:5000" ];
      autoStart = true;
      environment = {
        PUID = "989";
        PGID = "986";
      };
      volumes =[
        "/mnt/other1/picard-web:/picard-web:rw"
        "/mnt/other1/music:/music:rw"
        "/mnt/other1/soulseek:/soulseek:rw"
      ];
    };
  };
}