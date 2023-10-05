# VM that's prebuilt by the CI. This might speed the VM startup
# during the workshop up a bit.
{ pkgs, lib, ... }: {

  imports = [
    ./vm-codespaces.nix
  ];

  systemd.services.shutdown = {
    description = "automatic shutdown";
    script  = ''
      shutdown now
    '';
  };
  systemd.timers.shutdown = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnBootSec = "60s";
  };
  
}
