{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
  };

  outputs = { self, nixpkgs, home-manager, darwin, unstable, master }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [
          (final: prev: {
            nix-direnv = unstable.legacyPackages.${system}.nix-direnv;
            openmw = master.legacyPackages.${system}.openmw;
          })
        ];
      };
    in {
      nixosConfigurations.aanar-nixos = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aanar = import ./linux.nix;
          }
        ];
      };
      darwinConfigurations."userlike-macbook" = darwin.lib.darwinSystem {
        modules = [
          ./macos-configuration.nix
          home-manager.darwinModules.home-manager
          {
            users.users.anilanar.home = "/Users/anilanar";
            home-manager.useGlobalPkgs = true;
            # home-manager.useUserPackages = true;
            home-manager.users.anilanar = import ./macos.nix;
          }
        ];
      };
      shells = pkgs.callPackage ./shells { inherit pkgs; };
    };
}
