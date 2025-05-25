{ lib, ... }:

{
  imports = [
    ./nl.nix
  ];

  locale.nl.enable = 
    lib.mkDefault true;
}