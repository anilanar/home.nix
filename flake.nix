{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix.url = "github:anilanar/sops-nix/feat/home-manager-flake";
    nix-gaming.url = "github:fufexan/nix-gaming";
    shells.url = "github:anilanar/shells.nix";
  };

  outputs = { self, nixpkgs, home-manager, darwin, unstable, master, flake-utils
    , sops-nix, nix-gaming, shells }:
    let
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-13.6.9" "xen-4.10.4" ];
      };
      overlays = [ (import ./overlays.nix) ];
      linux = "x86_64-linux";
      macos = "x86_64-darwin";
      m1 = "aarch64-darwin";
    in {
      nixosConfigurations.aanar-nixos = nixpkgs.lib.nixosSystem {
        system = linux;
        pkgs = import nixpkgs {
          system = linux;
          inherit config;
          inherit overlays;
        };
        specialArgs = {
          inherit nixpkgs;
          unstable = import unstable {
            system = linux;
            inherit config;
            inherit overlays;
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
              nix-gaming = nix-gaming.packages.${linux};
              vscode = shells.packages.${linux}.vscode;

              unstable = import unstable {
                system = linux;
                inherit config;
                inherit overlays;
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
            home-manager.extraSpecialArgs = {
              sops = sops-nix.homeManagerModules.sops;
              vscode = shells.packages.${m1}.vscode;

              unstable = import unstable {
                system = m1;
                inherit config;
              };
            };
          }
        ];
      };
    };
}
