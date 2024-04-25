{ pkgs, lib, ... }:

# All services
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${lib.makeBinPath [ pkgs.hyprland ]}/Hyprland";
  username = "dezeekees";
in {

  # Open SSH
  services.openssh.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # # Display manager
  # services.xserver.enable = true;

  # services.displayManager = {
  #   sddm = {
  #     enable = true;
  #   };
  # };  

  # services.xserver.displayManager.setupCommands = ''
  #   ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --off
  # '';

  # greetd autologin
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --greeting 'Welcome to PwNixOS!' --cmd Hyprland";
        user = "${username}";
      };
      initial_session = {
        command = "${session}";
        user = "${username}";
      };
    };
  };
}