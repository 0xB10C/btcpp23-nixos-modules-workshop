{ pkgs, lib, ... }: {

  imports = [
    ./configuration.nix
    ./common.nix
  ];

  virtualisation = {
    cores = lib.mkDefault 2;
    memorySize = lib.mkDefault (3 * 1024);
    diskSize = lib.mkDefault (5 * 1024);
    writableStoreUseTmpfs = false;
    forwardPorts = [
      { from = "host"; host.port = 4242; guest.port = 4242; }
      { from = "host"; host.port = 2222; guest.port = 22; }
      { from = "host"; host.port = 8000; guest.port = 8000; }
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
        "/etc/nixos/" = {
          target = ./.;
          cache = "none";
        };
      };
    };
  };

}
