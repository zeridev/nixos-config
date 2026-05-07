# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
    zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
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

    zfs = {
      extraPools = [ "tank" ];
    };

    supportedFilesystems = {
      zfs = true;
    };

    kernelPackages = latestKernelPackage;
  };

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  networking.hostName = "shuna"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable networking
  networking.hostId = "c7c9475a";
  services.openssh.enable = true;
  services.tailscale.enable = true;

  myServices = {
    nextcloud = {
      enable = true;
      dataDir = "/mnt/chonker/nextcloud-data";
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
        "cloud.dezeekees.eu" = "http://localhost:${toString config.myServices.nextcloud.port}";
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

    docker = {
      enable = true;
      data-root = "/mnt/other1/docker-data";

      picard.enable = true;
      explo.enable = true;
    };

    hytale-server = {
      enable = false;
      dataDir = "/mnt/other1/hytale-server";
    };

    satisfactory-server = {
      enable = true;
      dataDir = "/mnt/other1/satisfactory-server";
    };
  };

  programs.ssh.startAgent = true;

  environment.systemPackages =
    with pkgs;
    [
      beets
      btop
      screen
    ]
    ++ [
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
