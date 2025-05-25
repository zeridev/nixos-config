{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let

    in
    {

      nixosConfigurations.shuna = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/shuna/configuration.nix
          ./modules
        ];
      };

    };
}
