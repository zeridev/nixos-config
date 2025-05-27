{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    { self, nixpkgs, agenix, ... }@inputs:
    let

    in
    {
      nixosConfigurations.shuna = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ({ ... }: {
            imports = [
              ./hosts/shuna/configuration.nix
              ./modules
              agenix.nixosModules.default
            ];

            _module.args = {
              flakeRoot = self;
            };
          })
        ];
      };

    };
}
