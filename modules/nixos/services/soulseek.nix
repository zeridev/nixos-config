{ config, lib, flakeRoot, ... }:
let
  cfg = config.myServices.soulseek;
  soulseekEnvFile = "${flakeRoot}/secrets/soulseek-envfile.age";
in
{
  options.myServices.soulseek = {
    enable = lib.mkEnableOption "Enables soulseek";

    port = lib.mkOption {
      type = lib.types.int;
      default = 50300;
    };

    webPort = lib.mkOption {
      type = lib.types.int;
      default = 5030;
    };

    dataDir = lib.mkOption {
      description = "where the data lives";
      default = "/var/lib/slskd";
    };
  };

  config = lib.mkIf cfg.enable {
    services.slskd = {
      enable = true;
      environmentFile = config.age.secrets."soulseek-envfile".path;
      domain = null;

      settings = {
        directories = {
          downloads = "${cfg.dataDir}/downloads";
          incomplete = "${cfg.dataDir}/incomplete";
        };

        shares.directories = [
          "${cfg.dataDir}/share"
        ];

        web = {
          https.disabled = true;
          port = cfg.webPort;
        };

        soulseek = {
          listen_port = cfg.port;
        };
      };
    };

    age.secrets."soulseek-envfile".file = soulseekEnvFile;
  };
}