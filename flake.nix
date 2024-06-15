{
  description = "David's config flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    swww.url = "github:LGFae/swww";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        davnix = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
        };
      };

      homeConfigurations = {
        daviddeadly = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { 
            inherit inputs;
            inherit pkgs-unstable;
          };

          modules = [ ./home.nix ];
        };
      };
    };
}
