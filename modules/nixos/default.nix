{ lib, pkgs, ... }: {
  imports = [
    ./users
    ./locales
    ./services
    
    ./os-settings.nix
    ./nix-language.nix
  ];

  nixLanguage.enable =
    lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    git
  ];
}