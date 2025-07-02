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
  ];
}