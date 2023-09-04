{ pkgs, ... }: {

  imports = [
    ./configuration.nix
  ];

  virtualisation = {
    cores = 2;
    memorySize = 3 * 1024;
    diskSize = 5 * 1024;
    writableStoreUseTmpfs = false;
  };

  nixos-shell = {
    mounts = {
      cache = "none"; # default is "loose"
      mountHome = false;
      mountNixProfile = false;
      extraMounts = {
        "/root/tasks" = {
          target = ./tasks;
          cache = "none";
        };
        "/etc/nixos/" = {
          target = ./.;
          cache = "none";
        };
      };
    };
  };

}
