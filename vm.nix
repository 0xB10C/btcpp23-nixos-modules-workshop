{ pkgs, ... }: {

  imports = [
    ./configuration.nix
    ./common.nix
  ];

  virtualisation = {
    cores = 2;
    memorySize = 3 * 1024;
    diskSize = 5 * 1024;
    writableStoreUseTmpfs = false;
    forwardPorts = [
      { from = "host"; host.port = 4242; guest.port = 4242; }
    ];
  };

  # nixos-shell disables the firewall by default. For this workshop we need it
  # to be enabled.
  networking.firewall.enable = true;

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
