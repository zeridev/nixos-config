{ pkgs, ... }:

{
  # Polkit
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
  ];
}