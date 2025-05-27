{ lib, config, ... }:
let
  cfg = config.myServices.onlyoffice;
in
{

  options.myServices.onlyoffice = {
    enable = lib.mkEnableOption "Enables onlyoffice document server";
    port = lib.mkOption {
      default = 80;
      description = "The default listening port";
    };
  };

  config = lib.mkIf cfg.enable {

    services.onlyoffice = {
      enable = true;
      hostname = "onlyoffice.dezeekees.eu";
      port = cfg.port;
    };

    services.nginx = {
      recommendedProxySettings = true;

      virtualHosts."${config.services.onlyoffice.hostname}" = {
        listen = [ { addr = "127.0.0.1"; port = cfg.port; } ];
      };
    };

  };

}