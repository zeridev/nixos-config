{ config, lib, ... }:
let 
  cfg = config.myServices.docker;
in 
{
  options.myServices.docker = {
    enable = lib.mkEnableOption "Enables docker";
    data-root = lib.mkOption {
      description = "where dockers stores data";
      type = lib.types.str;
      default = "/mnt/other1/docker-data";
    };


  };

  config = lib.mkIf cfg.enable {
    users.extraGroups.docker.members = [ "dezeekees" ];

    virtualisation = {
      docker = {
        enable = true;
        daemon.settings = {
          data-root = cfg.data-root;
        };
      };

      oci-containers.containers = {

        picard = {
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
    };
  };
}