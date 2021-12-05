{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, home-manager, darwin, unstable, master, flake-utils }:
    let
      getOverlays = import ./overlays.nix {
        inherit unstable;
        inherit master;
      };
      linux = "x86_64-linux";
      macos = "x86_64-darwin";
    in {
      nixosConfigurations.aanar-nixos = nixpkgs.lib.nixosSystem {
        system = linux;
        pkgs = import nixpkgs {
          system = linux;
          config = { allowUnfree = true; };
          overlays = [ (getOverlays linux) ];
        };
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
      lib = { eachSystem = flake-utils.lib.eachSystem [ macos linux ]; };

    } // flake-utils.lib.eachSystem [ macos linux ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ (getOverlays system) ];
        };
      in { packages = { shells = import ./shells { inherit pkgs; }; }; });
}
