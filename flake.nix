# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@ {nixpkgs, hyprland, self, ...}: 

  let
    system = "x86_64-linux";
  in {
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
