{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    agenix.url = "github:ryantm/agenix";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs =
    { self, nixpkgs, agenix, nix-minecraft, ... }@inputs:
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
              nix-minecraft.nixosModules.minecraft-servers
            ];

            nixpkgs.overlays = [
              nix-minecraft.overlay
            ];

            _module.args = {
              flakeRoot = self;
            };
          })
        ];
      };

    };
}
