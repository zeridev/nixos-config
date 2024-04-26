{ inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dezeekees = {
    isNormalUser = true;
    description = "dezeekees";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "dezeekees" = import ./home.nix;
    };
  };

}