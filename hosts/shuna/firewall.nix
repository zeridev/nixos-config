{ ... }:

{
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      22
      3210
      9091
    ];
    allowedUDPPorts = [ 53 ];
  };
}
