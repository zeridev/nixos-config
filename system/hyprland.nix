{ pkgs, ... }:

{
  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.gamescope = {
    enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-desktop-portal-hyprland
    ];
  };

  environment.systemPackages = with pkgs; [
    kitty
    wofi

    (pkgs.discord.override {
      # remove any overrides that you don't want
      withOpenASAR = true;
      withVencord = true;
    })

    github-desktop
    gnome.nautilus
    gnome.eog
    hyprlock
    hyprcursor
    wev
    unzip
    okteta # hex editor for gpu rom editing
    fastfetch
    mpv
    transmission-gtk
    htop
  ];

  fonts = {
    packages = with pkgs; [

      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })

    ];
  };
}