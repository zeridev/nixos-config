{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixarr = {
    #   url = "github:rasmus-kirk/nixarr";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # temporarily use forked version until merge request is accepted:
    nixarr = {
      url = "github:samagcarr/nixarr/patch-1";
      inputs.nixpkgs.follows = "nixpkgs";
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
