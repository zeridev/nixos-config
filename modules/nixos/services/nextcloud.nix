{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.myServices.nextcloud;
in
{
  options.myServices.nextcloud = {
    enable = lib.mkEnableOption "Enables nextcloud";
    dataDir = lib.mkOption {
      description = "Nextcloud's data storage path";
      default = "/mnt/nextcloud-file";
    };
    port = lib.mkOption {
      type = lib.types.int;
      description = "The port nextcloud is hosted on";
      default = 80;
    };
  };

  config = lib.mkIf cfg.enable {

    services.nextcloud = {
      enable = true;
      package = with pkgs; nextcloud31;
      hostName = "nextcloud.local";
      datadir = cfg.dataDir;
      database.createLocally = true;
      config = {
        adminpassFile = "/etc/nextcloud-admin-pass";
        dbtype = "mysql";
        dbname = "nextcloud";
        dbuser = "nextcloud";
      };
      https = true;
      settings = {
        trusted_domains = [
          "cloud.dezeekees.eu"
        ];
      };
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) twofactor_webauthn richdocuments;
      };
      extraAppsEnable = true;
      maxUploadSize = "50G";
    };
    
    services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [ { addr = "127.0.0.1"; port = cfg.port; } ];

    services.mysql = {
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [
        {
          name = "nextcloud";
          ensurePermissions = {
            "nextcloud.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    # Enable services that nextcloud depends on
    myServices = {
      mysql.enable = lib.mkDefault true;
      cloudflared.enable = lib.mkDefault true;
    };

    # ensure that the db is running *before* running the setup
    systemd.services."nextcloud-setup" = {
      requires = [ "mysql.service" ];
      after = [ "mysql.service" ];
    };

  };
}
