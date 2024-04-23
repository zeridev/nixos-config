{ pkgs, ... }:

# All services
{

  # Open SSH
  services.openssh.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Display manager
  services.xserver.enable = true;

  services.displayManager = {
    sddm = {
      enable = true;
    };
  };  

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --off
  '';
}