# dotfilesv2

My dotfiles, as managed by Nix.

## Setup

1. clone this repo somewhere on the machine
1. `sudo rm /etc/nixos/configuration.nix`
1. `sudo ln -s path/to/this/repo/machines/<machine-name>/configuration.nix /etc/nixos/configuration.nix`
1. `mkdir -p ~/.config/nixpkgs`
1. `ln -s path/to/this/repo/home.nix ~/.config/nixpkgs/home.nix`
