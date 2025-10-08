#!/usr/bin/env bash
set -e

# Clear old generations
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +5

# Clean old store paths
sudo nix-collect-garbage

# Update flake inputs
nix flake update

# Rebuild NixOS
sudo nixos-rebuild switch --flake ~/flake
