{
  lib,
  config,
  pkgs,
  ...
}:
let 
  cfg = config.myServices.cloudflared;
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
          credentialsFile = ../../../secrets/cloudflare/${cfg.tunnelId}.json;
          default = "http_status:404";
          ingress = cfg.ingress;
        };
      };
    };

    environment.systemPackages = with pkgs; [ cloudflared ];
  };
}
