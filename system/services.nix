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

  # Enable thrash
  services.gvfs.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # greetd autologin
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --greeting 'Welcome to Nixos!' --cmd Hyprland";
        user = "${username}";
      };
      initial_session = {
        command = "${session}";
        user = "${username}";
      };
    };
  };
}