{ ... }:

{
  imports = [
    ./nextcloud.nix
    ./mysql.nix
    ./cloudflared.nix
    ./onlyoffice.nix
    ./zerotier.nix
    ./nixarr.nix
    ./minecraft
  ];
}