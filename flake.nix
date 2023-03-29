# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs-stable-22-11.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = inputs@ {nixpkgs, hyprland, self, nixpkgs-stable-22-11, ...}: 

  let
    system = "x86_64-linux";
  in {
    overlays = {
      pkg-sets = (
        final: prev: {
	  stable-22-11 = import inputs.nixpkgs-stable-22-11 { system = final.system; };
        }
      );
    };
    nixosConfigurations = {
      hectic = nixpkgs.lib.nixosSystem {
        inherit system;
	# pkgs = nixpkgs.legacyPackages.${system};

	pkgs = import nixpkgs {
	  inherit system;
	  config = {
	    allowUnfree = true; 
	  };
	};
        modules = [
          ./configuration.nix
          hyprland.nixosModules.default
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
