{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    copyparty.url = "github:9001/copyparty";

    nixarr = {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    { self, nixpkgs, agenix, nix-minecraft, nixarr, copyparty, ... }@inputs:
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
              nixarr.nixosModules.default
              copyparty.nixosModules.default
            ];

            nixpkgs.overlays = [
              nix-minecraft.overlay
              copyparty.overlays.default
            ];

            _module.args = {
              flakeRoot = self;
            };
          })
        ];
      };

    };
}
