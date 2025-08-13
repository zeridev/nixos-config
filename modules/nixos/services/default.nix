{ ... }:

{
  imports = [
    ./nextcloud.nix
    ./mysql.nix
    ./cloudflared.nix
    ./collabora.nix
    ./zerotier.nix
    ./nixarr.nix
    ./minecraft
    ./soulseek.nix
    ./navidrome.nix
    ./copyparty.nix
  ];
}