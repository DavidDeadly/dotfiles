{
  description = "David's config flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    swww.url = "github:LGFae/swww";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        davnix = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
          ];
        };
      };

      homeConfigurations = {
        daviddeadly = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit inputs; };

          modules = [
            ./home.nix
          ];
        };
      };
    };
}
