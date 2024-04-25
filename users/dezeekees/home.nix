{ inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dezeekees";
  home.homeDirectory = "/home/dezeekees";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs = {
    overlays = [
      inputs.nur.overlay
    ];
    config.allowUnfree = true;
  };

  imports = [
    ./programs/vscode.nix
    ./programs/firefox.nix
    ./programs/easyeffects.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    
    # Home Base
    ".bashrc".source = ./config/bash/.bashrc;

    # Config Dir
    ".config/Code/User/settings.json".source = ./config/vscode/settings.json;
    ".config/hypr/hyprland.conf".source = ./config/hyprland/hyprland.conf;
    ".config/hypr/hyprlock.conf".source = ./config/hyprland/hyprlock.conf;

    # wappapers
    ".config/wallpapers".source = ./config/wallpapers;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dezeekees/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };



  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
