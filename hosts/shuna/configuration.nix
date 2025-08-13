# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./firewall.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "shuna"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable networking
  services.openssh.enable = true;
  services.tailscale.enable = true;

  myServices = {
    nextcloud = {
      enable = true;
      dataDir = "/mnt/nextcould-data";
      port = 8080;
    };

    mysql = {
      enable = true;
      dataDir = "/mnt/mysqldata";
    };

    collabora = {
      enable = true;
      port = 9980;
      wopiHosts = [ "cloud.dezeekees.eu" ];
      serverName = "collabora.dezeekees.eu";
    };

    cloudflared = {
      enable = true;
      tunnelId = "9bece06c-8915-4260-a21f-d433f49575af";
      ingress = {
        "cloud.dezeekees.eu" = "http://localhost:${builtins.toString config.myServices.nextcloud.port}";
        "jelly.dezeekees.eu" = "http://localhost:8096";
        "sonarr.dezeekees.eu" = "http://localhost:8989";
        "radarr.dezeekees.eu" = "http://localhost:7878";
        "prowlarr.dezeekees.eu" = "http://localhost:9696";
        "collabora.dezeekees.eu" = "http://localhost:9980";
        "soulsearch.dezeekees.eu" = "http://localhost:5030";
        "navi.dezeekees.eu" = "http://localhost:4533";
      };
    };

    zerotier = {
      enable = true;
    };

    minecraft = {
      enable = true;
      dataDir = "/mnt/other1/minecraft";
      servers = {
        newgame.enable = false;
      };
    };

    nixarr = {
      enable = true;
      mediaDir = "/mnt/jellyfin-data";
      stateDir = "/mnt/jellyfin-data/.state";
      vpn = {
        port = 51820;
      };
    };

    soulseek = {
      enable = true;
      dataDir = "/mnt/other1/soulseek";
    };

    navidrome = {
      enable = true;
      musicDir = "/mnt/other1/music";
    };

    copyparty = {
      enable = true;
      port = 3210;
    };
  };

  programs.ssh.startAgent = true;

  environment.systemPackages = with pkgs; [
    beets
  ] ++ [
    inputs.agenix.packages.x86_64-linux.default
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
