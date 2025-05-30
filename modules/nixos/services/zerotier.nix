{ config, lib, ... }:
let
  cfg = config.myServices.zerotier;
in
{
  options.myServices.zerotier = {
    enable = lib.mkEnableOption "Enables Zerotier";
  };

  config = lib.mkIf cfg.enable {

    services.zerotierone = {
      enable = true;
      joinNetworks = [ "db64858fed3412c0" ];
    };

  };
}