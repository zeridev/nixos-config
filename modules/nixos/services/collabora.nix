{ lib, config, ... }:
let
  cfg = config.myServices.collabora;
in
{
  options.myServices.collabora = {
    enable = lib.mkEnableOption "Enables Collabora module";

    port = lib.mkOption {
      type = lib.types.int;
      description = "port of collabora";
      default = 9980;
    };

    wopiHosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "list of allowed wofi hosts";
      default = [];
    };

    serverName = lib.mkOption {
      type = lib.types.str;
      description = "the addres of the collabora server";
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {

    services.collabora-online = {
      enable = true;
      port = cfg.port; # default
      settings = {
        # Rely on reverse proxy for SSL
        ssl = {
          enable = false;
          termination = true;
        };

        # Listen on loopback interface only, and accept requests from ::1
        net = {
          listen = "loopback";
          post_allow.host = ["::1" "127.0.0.1"];
        };

        # Restrict loading documents from WOPI Host nextcloud.example.com
        storage.wopi = {
          "@allow" = true;
          host = cfg.wopiHosts;
        };

        # Set FQDN of server
        server_name = cfg.serverName;
      };
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."collabora.example.com" =  {
        listen = [ { addr = "127.0.0.1"; port = cfg.port; } ];
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.collabora-online.port}";
          proxyWebsockets = true; # collabora uses websockets
        };
      };
    };

    systemd.services.nextcloud-config-collabora = let
      inherit (config.services.nextcloud) occ;

      wopi_url = "http://[::1]:${toString cfg.port}";
      public_wopi_url = "https://${cfg.serverName}";
      wopi_allowlist = lib.concatStringsSep "," [
        "127.0.0.1"
        "::1"
      ];
    in {
      wantedBy = ["multi-user.target"];
      after = ["nextcloud-setup.service" "coolwsd.service"];
      requires = ["coolwsd.service"];
      script = ''
        ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_url --value ${lib.escapeShellArg wopi_url}
        ${occ}/bin/nextcloud-occ config:app:set richdocuments public_wopi_url --value ${lib.escapeShellArg public_wopi_url}
        ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_allowlist --value ${lib.escapeShellArg wopi_allowlist}
        ${occ}/bin/nextcloud-occ richdocuments:setup
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}