{ config, lib, pkgs, ... }:
let 
  cfg = config.myServices.satisfactory-server;
in
{
  options.myServices.satisfactory-server = {
    enable = lib.mkEnableOption "Enables satisfactory-server";
    dataDir = lib.mkOption {
      description = "The path where satisfactory-server stores its files";
      default = "/mnt/other1/satisfactory-server";
    };
  };

  config = lib.mkIf cfg.enable {
    
    users = {
      groups.satisfactory = { };
      extraUsers.satisfactory= {
        isSystemUser = true;
        group = "satisfactory";
        home = cfg.dataDir;
        createHome = true;
        packages = with pkgs; [ steamcmd ];
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 7777 8888 ];
      allowedUDPPorts = [ 7777 ];
    };

    environment.systemPackages = with pkgs; [ steamcmd ];

    systemd = {
      services = {
        satisfactory-server = {
          description = "Satisfactory Dedicated Server";
          after = [
            "syslog.target"
            "network.target"
            "nss-lookup.target"
            "network-online.target"
          ];
          wants = [ "network-online.target" ];

          serviceConfig = {
            ExecStartPre = "${pkgs.steamcmd}/bin/steamcmd +force_install_dir \"${cfg.dataDir}\" +login anonymous +app_update 1690800 -beta experimental validate +quit";
            ExecStart = "${cfg.dataDir}/FactoryServer.sh";
            ExecStopPost="${pkgs.coreutils}/bin/sleep 60";
            User = "satisfactory";
            Group = "satisfactory";
            Restart = "on-failure";
            RestartSec = "60s";
            KillSignal = "SIGINT";
            WorkingDirectory = cfg.dataDir;
          };

          wantedBy = [ "multi-user.target" ];
        };

        satisfactory-server-restart = {
          description = "Restart the Satisfactory Dedicated Server";

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.systemd}/bin/systemctl restart satisfactory-server.service";
          };

          wantedBy = [ "multi-user.target" ];
        };
      };

      timers = {
        satisfactory-server-restart = {
          description = "Restart the Satisfactory Dedicated Server every 24 hours";
          wantedBy = [ "timers.target" ];

          timerConfig = {
            OnCalendar = "*-*-* 04:00:00";
            Persistent = true;
          };
        };
      };

    };
  };

}