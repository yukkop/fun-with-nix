# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@ {nixpkgs, hyprland, ...}: {
    nixosConfigurations = {
      hectic = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          hyprland.nixosModules.default
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
