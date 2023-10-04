{ pkgs, lib, ... }: {

  imports = [
    ./vm.nix
  ];

  virtualisation = {
    cores = 1;
    memorySize = 4 * 1024;
  };
}
