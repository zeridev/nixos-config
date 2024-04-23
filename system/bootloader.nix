{ pkgs, ... }:

{
  # Bootloader.
  boot = {

    loader = {
      
      systemd-boot = {
        enable = true;
      };

      efi.canTouchEfiVariables = true;
    };

    initrd = {
      enable = true;
      systemd.enable = true;
    };

    plymouth = {
      enable = true;
      themePackages = with pkgs; [
        plymouth
      ];
      theme = "bgrt";
    };

  };
}