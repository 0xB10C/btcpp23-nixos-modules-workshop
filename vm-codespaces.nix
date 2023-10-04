{ pkgs, lib, ... }: {

  imports = [
    ./vm.nix
  ];

  virtualisation = {
    cores = 1;
    memorySize = 4 * 1024;
  };

  environment.interactiveShellInit = ''
    alias nixos-rebuild='echo "Due to the VM being emulated, everything is quite slow in here. Do not run nixos-rebuild in the VM. Use   sh nixos-rebuild-vm.sh   from the host for this workshop."'
  '';
}
