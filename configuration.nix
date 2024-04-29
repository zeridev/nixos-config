# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define your hostname.
  networking.hostName = "dezeekeespc"; 

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "23.11";
}
