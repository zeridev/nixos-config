# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, ... }:

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

    cloudflared = {
      enable = true;
      tunnelId = "9bece06c-8915-4260-a21f-d433f49575af";
      ingress = {
        "cloud.dezeekees.eu" = "http://localhost:${builtins.toString config.myServices.nextcloud.port}";
      };
    };
  };

  programs.ssh.startAgent = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
