{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.4.0";
    nix-gaming.url = "github:fufexan/nix-gaming";
    wired.url = "github:Toqozz/wired-notify";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs =
    inputs@{
      self,
      darwin,
      home-manager,
      flake-utils-plus,
      nix-gaming,
      wired,
      vscode-server,
      ...
    }:
    let
      linux = "x86_64-linux";
      m1 = "aarch64-darwin";
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          # "electron-13.6.9" 
          # "xen-4.10.4"
          "electron-25.9.0"
        ];
      };
      overlays = [
        (import ./overlays.nix)
        wired.overlays.default
      ];
    in
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      nix = {
        generateRegistryFromInputs = true;
        generateNixPathFromInputs = true;
        linkInputs = true;
      };

      supportedSystems = [
        linux
        m1
      ];

      channelsConfig = config;
      sharedOverlays = overlays;

      hostDefaults.extraArgs = {
        unstable = import inputs.unstable {
          system = linux;
          inherit config;
          inherit overlays;
        };
      };

      hosts.aanar-nixos = {
        system = linux;
        extraArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aanar = import ./aanar/linux.nix;
            home-manager.users."0commitment" = import ./0commitment/linux.nix;
            home-manager.extraSpecialArgs = {
              wired = wired.homeManagerModules.default;
              nix-gaming = nix-gaming.packages.${linux};
              vscode-server = vscode-server.homeModules.default;
              unstable = import inputs.unstable {
                system = linux;
                inherit config;
                inherit overlays;
              };
            };
          }
        ];
      };

      hosts.userlike-macbook = {
        output = "darwinConfigurations";
        builder = darwin.lib.darwinSystem;

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
              unstable = import inputs.unstable {
                system = m1;
                inherit config;
              };
            };
          }
        ];
      };
    };
}
