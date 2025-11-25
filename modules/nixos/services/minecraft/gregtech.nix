{ config, lib, pkgs, ... }:
let
  cfg = config.myServices.minecraft.servers.gregtech;
  javaVersion = with pkgs; jdk17;
in
{
  options.myServices.minecraft.servers.gregtech = {
    enable = lib.mkEnableOption "Enables the gregtech minecraft server";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.minecraft-gregtech = {
      enable = true;
      description = "Forge Minecraft Server - gregtech new horizons port 25575";
      serviceConfig = {
        ExecStart = "${pkgs.screen}/bin/screen -DmS gregtech ${javaVersion}/bin/java -Xms8G -Xmx8G -Dfml.readTimeout=180 @java9args.txt -jar lwjgl3ify-forgePatches.jar nogui";
        WorkingDirectory = "${config.users.extraUsers.minecraft.home}/gregtech";
        Restart = "always";
        RestartSec = 60;
      };
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
    };

    networking.firewall = {
      allowedTCPPorts = [ 25575 ];
      allowedUDPPorts = [ 25575 ];
    };
  };
}