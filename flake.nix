{
  description = "David's config flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {self, nixpkgs, ...}@inputs: 
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
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
        modules = [
          ./home.nix
        ];
      };
    };
  };
}
