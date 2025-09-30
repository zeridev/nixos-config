#!/usr/bin/env bash
set -e

# Update flake inputs
nix flake update

# Rebuild NixOS
sudo nixos-rebuild switch --flake ~/flake

# Remove old generations older than 14 days
sudo nix-collect-garbage --delete-older-than 14d
