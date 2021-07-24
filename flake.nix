{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin }: {

    nixosConfigurations.aanar-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
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
          home-manager.useUserPackages = true;
          home-manager.users.anilanar = import ./macos.nix;
        }
      ];
    };

  };
}
