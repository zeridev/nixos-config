{ config, pkgs, lib, ... }:
let
  cfg = config.myServices.hytale-server;
  javaVersion = pkgs.jdk25;
in
{

  options.myServices.hytale-server = {
    enable = lib.mkEnableOption "Enables the hytale server";
    dataDir = lib.mkOption {
      description = "The path where the server stores its files";
      default = "/var/lib/hytale";
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.hytale = { };
      extraUsers.hytale = {
        isSystemUser = true;
        group = "hytale";
        home = cfg.dataDir;
        createHome = true;
        packages = [
          javaVersion
        ];
      };
    };

    # systemd.services = {
    #   hytale-server = {
    #     description = "Hytale Server";
    #     after = [
    #       "network.target"
    #       "network-online.target"
    #     ];
    #     wants = [ "network-online.target" ];
    #     serviceConfig = {
    #       User = "hytale";
    #       WorkingDirectory = cfg.dataDir;
    #       ExecStart = "${javaVersion}/bin/java -Xmx4G -Xms2G -jar hytale-server.jar nogui";
    #       Restart = "on-failure";
    #       RestartSec = "10s";
    #       LimitNOFILE = 65536;
    #     };
    #     wantedBy = [ "multi-user.target" ];
    #   };

    #   hytale-server-update = {
    #     description = "Hytale Server Updater";
    #     after = [ "hytale-server.service" ];
    #     serviceConfig = {
    #       Type = "oneshot";
    #       User = "hytale";
    #       WorkingDirectory = cfg.dataDir;
    #       ExecStart = "${pkgs.curl}/bin/curl -o hytale-server.jar https://example.com/path/to/latest/hytale-server.jar";
    #     };
    #     wantedBy = [ "multi-user.target" ];
    #   };
    };
  };

}
