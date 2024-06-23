{
  description = "David's config flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swww.url = "github:LGFae/swww";

    woomer.url = "github:coffeeispower/woomer";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    pyprland.url = "github:hyprland-community/pyprland";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      inherit (nixpkgs) lib;
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      pkgs-unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    in
    {
      devShells.${system} =
        builtins.listToAttrs (
          builtins.map
            (name: {
              inherit name;
              value = import ./shells/${name}.nix { inherit pkgs; };
            })
            [
              "js"
              "go"
            ]
        );
      # above is exactly the same as declaring manually the following set:
      # {
      # js = import ./shells/js.nix { inherit pkgs; };
      # go = import ./shells/go.nix { inherit pkgs; };
      # }

      nixosConfigurations = {
        davnix = lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./hosts/davnix/configuration.nix

            inputs.lanzaboote.nixosModules.lanzaboote
            ({ pkgs, lib, ... }: {
              environment.systemPackages = [
                # For debugging and troubleshooting Secure Boot.
                pkgs.sbctl
              ];

              boot.loader.systemd-boot.enable = lib.mkForce false;

              boot.lanzaboote = {
                enable = true;
                pkiBundle = "/etc/secureboot";
              };
            })
          ];
        };
      };

      homeConfigurations = {
        daviddeadly = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };

          modules = [
            ./home/hyprdeadly/home.nix
          ];
        };
      };
    };
}
