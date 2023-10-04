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

  # alias nixos-rebuild switch to nixos-rebuild switch with verbose output
  # this helps to show that there's still progress and we're not stuck..
  environment.interactiveShellInit = ''
    alias nixos-rebuild='nixos-rebuild --verbose -vv --fast'
  '';

  # enable ssh access to the VM
  services.openssh.enable = true;

  system.stateVersion = "23.05";
}
