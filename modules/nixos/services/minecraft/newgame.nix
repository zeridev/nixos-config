{ config, lib, pkgs, ... }:
let
  cfg = config.myServices.minecraft.servers.newgame;
  javaVersion = with pkgs; jdk17;
in
{
  options.myServices.minecraft.servers.newgame = {
    enable = lib.mkEnableOption "Enables the newgame minecraft server";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.minecraft-newgame = {
      enable = true;
      description = "Forge Minecraft Server - newgame";
      serviceConfig = {
        ExecStart = "${javaVersion}/bin/java -Xms1G -Xmx8G @libraries/net/minecraftforge/forge/1.20.1-47.4.0/unix_args.txt '$@'";
        WorkingDirectory = "${config.users.extraUsers.minecraft.home}/newgame";
        Restart = "always";
        RestartSec = 60;
      };
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
    };

    networking.firewall = {
      allowedTCPPorts = [ 25565 ];
      allowedUDPPorts = [ 25565 ];
    };
  };
}