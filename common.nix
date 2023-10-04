# This file is imported in vm.nix and rebuild.nix. It defines common
# options.
let
  keys = map (key: "${builtins.getEnv "HOME"}/.ssh/${key}")
    [ "id_rsa.pub" "id_ecdsa.pub" "id_ed25519.pub" ];
in
{ pkgs, modulesPath, lib, ... }: {

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

  # from https://github.com/Mic92/nixos-shell/blob/65489e7eeef8eeea43e1e4218ad1b99d58852c7c/share/modules/nixos-shell-config.nix#L35
  # Allow passwordless ssh login with the user's key if it exists.
  users.users.root.openssh.authorizedKeys.keyFiles = lib.filter builtins.pathExists keys;

  system.stateVersion = "23.05";
}
