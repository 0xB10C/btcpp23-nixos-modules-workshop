# This file is used to nixos-rebuild the VM from inside the VM. A few things
# that are declared by nixos-shell are re-declared here.

{ pkgs, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
    ./configuration.nix
  ];

  # We don't want to install a bootloader as the nixos-shell takes care of
  # starting the VM.
  boot.loader.grub.enable = false;
  # This is set by nixos-shell too, and we re-declare it here just to be sure.
  users.extraUsers.root.initialHashedPassword = "";
}
