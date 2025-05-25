{ lib, config, pkgs, ... }:

{
  options = {
    myServices.mysql = {
      enable = lib.mkEnableOption "Enables mysql with the mariadb package";
      dataDir = lib.mkOption {
        default = "/var/lib/mysql";
        description = "The data directory for MySQL";
      };
    };
  };

  config = lib.mkIf config.myServices.mysql.enable {

    services.mysql = {
      enable = true;
      package = with pkgs; mariadb;
      dataDir = config.myServices.mysql.dataDir;
    };

  };
}