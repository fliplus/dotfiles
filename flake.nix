{
  description = "flip's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... } @ inputs:
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };

    host = "onemore";
    user = "flip";
  in
  {
    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit pkgs inputs host user; };
      modules = [
        inputs.disko.nixosModules.disko
        inputs.impermanence.nixosModules.impermanence

        ./hosts/${host}
        ./nixos/configuration.nix

        inputs.home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = { inherit pkgs inputs host user; };
          home-manager.users.${user} = {
            imports = [
              inputs.nixvim.homeManagerModules.nixvim
              ./home-manager/home.nix
            ];
          };
        }

        (nixpkgs.lib.mkAliasOptionModule [ "hm" ] [
          "home-manager"
          "users"
          user
        ])
      ];
    };
  };
}
