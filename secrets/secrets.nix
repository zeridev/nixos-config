let
  shuna = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPUPnaOTD6ZS6i1+G3/BhMbuSbQ1gVVPpM7Do67ThEdA root@nixos";
in {
  "cloudflared.age".publicKeys = [ shuna ];
  "nixarr-wgconf.age".publicKeys = [ shuna ];
}