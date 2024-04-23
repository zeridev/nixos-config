# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define your hostname.
  networking.hostName = "dezeekeespc"; 

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  system.stateVersion = "23.11";
}
