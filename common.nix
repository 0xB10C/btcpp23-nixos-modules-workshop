# This file is imported in vm.nix and rebuild.nix. It defines common
# options.

{ pkgs, modulesPath, ... }: {

  imports = [
    "${modulesPath}/profiles/minimal.nix"
  ];

  # otherwise some stuff is build from source, which we want to
  # avoid for the workshop
  environment.noXlibs = false;

  # don't touch these options during the workshop
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nix.nixPath = [
    "nixpkgs=${pkgs.path}"
    # running nixos-rebuild uses the nixos-config path. We use the rebuild.nix
    # file here. It imports configuration.nix and defines a few things we need
    # as we are in a VM.
    "nixos-config=/etc/nixos/rebuild.nix"
  ];

  system.stateVersion = "23.05";
}
