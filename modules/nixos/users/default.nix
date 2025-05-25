{ lib, ... }:

{
  imports = [
    ./dezeekees.nix
  ];

  users.dezeekees.enable =
    lib.mkDefault true;
}