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
        packages = with pkgs;
        [
          javaVersion
          unzip
        ];
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 5520 ];
      allowedUDPPorts = [ 5520 ];
    };

    systemd.services = {
      hytale-server = {
        description = "Hytale Server";
        after = [
          "network.target"
          "network-online.target"
        ];
        wants = [ "network-online.target" ];

        serviceConfig = {
          User = "hytale";
          WorkingDirectory = cfg.dataDir;
          ExecStart = "${javaVersion}/bin/java -Xmx8G -XX:AOTCache=./server/Server/HytaleServer.aot -jar ./server/Server/HytaleServer.jar --assets ./server/Assets.zip --bind 0.0.0.0:5520";
          Restart = "always";
          RestartSec = "10s";
          LimitNOFILE = 65536;

          StandardInput = "journal";
          StandardOutput = "journal";
          StandardError = "journal";
        };

        wantedBy = [ "multi-user.target" ];
      };

      hytale-server-update = {
        description = "Hytale Server Updater";

        conflicts = [ "hytale-server.service" ];
        after = [ "hytale-server.service" ];

        serviceConfig = {
          Type = "oneshot";
          User = "hytale";
          WorkingDirectory = cfg.dataDir;
          ExecStart = [
            "/mnt/other1/hytale-server/hytale-downloader-linux-amd64 -download-path ./server.zip"
            "${pkgs.unzip}/bin/unzip ./server.zip -d ./server"
          ];
        };
      };
    };
  };

}
