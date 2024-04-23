{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/nur";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        ./users/dezeekees/user.nix
        ./system/system.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
