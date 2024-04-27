{ ... }:

{
  imports = [
    ./bootloader.nix
    ./hyprland.nix
    ./locale.nix
    ./nvidia.nix
    ./pipewire.nix
    ./polkit.nix
    ./services.nix
    ./virt.nix
    ./anime-game.nix
  ];

  programs.dconf.enable = true;
  programs.git.enable = true;
  hardware.ckb-next.enable = true;
}