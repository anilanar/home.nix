{ unstable, master }:
system: final: prev: {
  nix-direnv = unstable.legacyPackages.${system}.nix-direnv;
  openmw = master.legacyPackages.${system}.openmw;
}
