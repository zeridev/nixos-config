{ ... }:

{
  imports = [
    ./nextcloud.nix
    ./mysql.nix
    ./cloudflared.nix
    ./collabora.nix
    ./zerotier.nix
    ./nixarr.nix
    ./soulseek.nix
    ./navidrome.nix
    ./copyparty.nix
    ./docker.nix
    ./hytale-server.nix
    ./satisfactory-server.nix
  ];
}