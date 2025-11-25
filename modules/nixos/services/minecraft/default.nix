{ config, lib, pkgs, ... }:
let
  cfg = config.myServices.minecraft;
in
{
  imports = [
    ./gregtech.nix
  ];

  options.myServices.minecraft = {
    enable = lib.mkEnableOption "Enables the minecraft servers";
    dataDir = lib.mkOption {
      description = "The path where the servers store their files";
      default = "/var/lib/minecraft";
    };
  };

  config = lib.mkIf cfg.enable {

    users = {
      groups.minecraft = {};
      extraUsers.minecraft = {
        isSystemUser = true;
        group = "minecraft";
        home = cfg.dataDir;
        createHome = true;
        packages = with pkgs; [
          jdk17
        ];
      };
    };

  };
}