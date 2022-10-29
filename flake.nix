{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix.url = "github:anilanar/sops-nix/feat/home-manager-flake";
  };

  outputs = { self, nixpkgs, home-manager, darwin, unstable, master, flake-utils
    , sops-nix }:
    let
      getOverlays = import ./overlays.nix {
        inherit unstable;
        inherit master;
      };
      linux = "x86_64-linux";
      macos = "x86_64-darwin";
      m1 = "aarch64-darwin";
      pkgConfig = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-13.6.9" ];
      };
    in {
      nixosConfigurations.aanar-nixos = nixpkgs.lib.nixosSystem {
        system = linux;
        pkgs = import nixpkgs {
          system = linux;
          config = pkgConfig;
          overlays = [ (getOverlays linux) ];
        };
        specialArgs = {
          inherit nixpkgs;
          unstable = import unstable {
            system = linux;
            config = pkgConfig;
            overlays = [ (getOverlays linux) ];
          };
        };
        modules = [
          (import ./configuration.nix)
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aanar = import ./aanar/linux.nix;
            home-manager.users."0commitment" = import ./0commitment/linux.nix;
            home-manager.extraSpecialArgs = {
              sops = sops-nix.homeManagerModules.sops;
              unstable = import unstable {
                system = linux;
                config = pkgConfig;
                overlays = [ (getOverlays linux) ];
              };
            };
          }
        ];
      };
      darwinConfigurations."userlike-macbook" = darwin.lib.darwinSystem {
        system = m1;

        modules = [
          ./macos-configuration.nix
          home-manager.darwinModules.home-manager
          {
            users.users.anilanar.home = "/Users/anilanar";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.anilanar = import ./aanar/macos.nix;
          }
        ];
      };
      lib = { eachSystem = flake-utils.lib.eachSystem [ macos m1 linux ]; };

    } // flake-utils.lib.eachSystem [ macos m1 linux ] (system:
      let
        pkgs = import unstable {
          system = linux;
          config = pkgConfig;
          overlays = [ (getOverlays linux) ];
        };
      in { packages = { shells = import ./shells { inherit pkgs; }; }; });
}
