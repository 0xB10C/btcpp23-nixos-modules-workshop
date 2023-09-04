# This file is imported by vm.nix and rebuild.nix. Declare services and common
# options here.

{ pkgs, ... }: {

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.nixPath = [
    "nixpkgs=${pkgs.path}"
    # running nixos-rebuild uses the nixos-config path. We use the rebuild.nix
    # file here. It imports configuration.nix and defines a few things we need
    # as we are in a VM.
    "nixos-config=/etc/nixos/rebuild.nix"
  ];

  documentation.enable = false;

  system.stateVersion = "23.05";
}
