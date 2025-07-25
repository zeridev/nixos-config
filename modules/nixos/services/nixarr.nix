{ config, lib, flakeRoot, ... }:
let
  cfg = config.myServices.nixarr;
  wgConf = "${flakeRoot}/secrets/nixarr-wgconf.age";
in
{
  options.myServices.nixarr = {
    enable = lib.mkEnableOption "Enables nixarr";

    mediaDir = lib.mkOption {
      description = "where media gets stored";
      default = "/data/media";
    };

    stateDir = lib.mkOption {
      description = "where media gets stored";
      default = "/data/media/.state/nixarr";
    };

    vpn =  {
      port = lib.mkOption {
        type = lib.types.int;
        description = "port of the vpn";
        default = 50000;
      };

      openUdpPorts = lib.mkOption {
        type = with lib.types; listOf int;
        default = [];
      };

      openTcpPorts = lib.mkOption {
        type = with lib.types; listOf int;
        default = [];
      };
    };
  };

  config = lib.mkIf cfg.enable {

    nixarr = {
      enable = true;

      mediaDir = cfg.mediaDir;
      stateDir = cfg.stateDir;

      vpn = {
        enable = true;
        wgConf = config.age.secrets."nixarr-wgconf".path;

        vpnTestService = {
          enable = true;
          port = cfg.vpn.port;
        };

        openUdpPorts = cfg.vpn.openUdpPorts;
        openTcpPorts = cfg.vpn.openUdpPorts;
      };

      jellyfin.enable = true;

      transmission = {
        enable = true;
        vpn.enable = true;
        peerPort = cfg.vpn.port;
      };

      prowlarr.enable = true;
      sonarr.enable = true;
      radarr.enable = true;
      # jellyseerr.enable = true;
    };

    age.secrets."nixarr-wgconf".file = wgConf;

    networking.firewall = {
      allowedTCPPorts = [ cfg.vpn.port ];
      allowedUDPPorts = [ cfg.vpn.port ];
    };

  };
}