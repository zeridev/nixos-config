{ ... }:

{
  imports = [
    ./nextcloud.nix
    ./mysql.nix
    ./cloudflared.nix
  ];
}