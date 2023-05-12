#!/usr/bin/env sh
nix build .#darwinConfigurations.userlike-macbook.system && ./result/sw/bin/darwin-rebuild switch --flake .#userlike-macbook