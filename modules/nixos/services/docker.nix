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
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [ "dezeekees" ];

    virtualisation.docker.daemon.settings = {
      data-root = cfg.data-root;
    };
  };
}