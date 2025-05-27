{
  lib,
  config,
  pkgs,
  flakeRoot,
  ...
}:
let 
  cfg = config.myServices.cloudflared;
  secretPath = "${flakeRoot}/secrets/cloudflared.age";
in
{
  options.myServices.cloudflared = {
    enable = lib.mkEnableOption "Enables cloudflare tunnels";
    tunnelId = lib.mkOption {
      description = "The id of the cloudflare tunnel";
    };
    ingress = lib.mkOption {
      default = {};
      description = "Ingress rules";
    };
  };

  config = lib.mkIf cfg.enable {
    services.cloudflared = {
      enable = true;
      package = with pkgs; cloudflared;
      tunnels = {
        "${cfg.tunnelId}" = {
          credentialsFile = config.age.secrets."cloudflared".path;
          default = "http_status:404";
          ingress = cfg.ingress;
        };
      };
    };

    age.secrets."cloudflared".file = secretPath;

    environment.systemPackages = with pkgs; [ cloudflared ];
  };
}
