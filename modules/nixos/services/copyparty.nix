{ config, lib, flakeRoot, ... }:
let
  cfg = config.myServices.copyparty;
  zeriPasswordFile = "${flakeRoot}/secrets/copyparty-passwd-zeri.age";
in 
{
  options.myServices.copyparty = {
    enable = lib.mkEnableOption "Enables copyparty";

    port = lib.mkOption {
      description = "the port copyparty runs on";
      type = lib.types.int;
    };
  };

  config = lib.mkIf cfg.enable {
    services.copyparty = {
      enable = true;

      settings = {
        i = "0.0.0.0";
        p = [ cfg.port ];
      };

      accounts = {
        zeri.passwordFile = config.age.secrets."copyparty-passwd-zeri".path;
      };

      volumes = {
        "/" = {
          path = "/mnt/other1/music";
          access = {
            A = [ "zeri" ];
          };
        };
      };
    };

    age.secrets."copyparty-passwd-zeri" = {
      file = zeriPasswordFile;
      owner = "copyparty";
    };

    users.users.copyparty.extraGroups = [ "music" ];
  };
}