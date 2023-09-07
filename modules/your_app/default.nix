{ config, pkgs, lib, ... }:

with lib;

let
  pkg = pkgs.callPackage ../../pkgs/your_app {};
  cfg = config.services.your_app;
in
{
  # imports = [ paths of other modules ];

  # option declarations
  options = {

    services.your_app = {
      enable = mkEnableOption "your_app";
      ## FIXME: Task 2.1: Declare options for the your_app service

    };

  };

  # Option definitions: The place where we use the options declared above to
  # define options from other NixOS modules.
  #
  # `mkIf` makes the following option definitions conditional on the module being enabled.
  # See https://nixos.org/manual/nixos/stable/#sec-option-definitions-delaying-conditionals
  config = mkIf cfg.enable {

    # We define the systemd service called your_app.
    # NixOS takes care of creating the necessary service files.
    systemd.services.your_app_server = {
      description = "your_app server daemon";

      # systemd's `wantedBy` means that this service should be started for the
      # specified target to be reached. The `multi-user.target` normally defines
      # a system state where all network services are started up and the system
      # will accept logins
      wantedBy = [ "multi-user.target" ];
      # This should however only happen after the target `network-online` is
      # reached as we are using the network interfaces in our your_app
      after = [ "network-online.target" ];

      # The systemd service configuration
      # See https://www.freedesktop.org/software/systemd/man/systemd.service.html
      serviceConfig = {
        ExecStart = ''${pkg}/bin/your_app \
          --rpc-host FIXME: Task 2.2 \
          --rpc-port FIXME: Task 2.2 \
          --rpc-user FIXME: Task 2.2 \
          --rpc-password FIXME: Task 2.2 \
          server FIXME: Task 2.2
        '';
      };

    };

    # Task 3
    systemd.services.your_app_backup = {
      description = "your_app server backup";
      after = [ "network-online.target" ];
      script = ''
      echo "starting backup..."
      ${pkg}/bin/your_app \
        --rpc-host FIXME: Task 4 \
        --rpc-port FIXME: Task 4 \
        --rpc-user FIXME: Task 4 \
        --rpc-password FIXME: Task 4 \
        backup
      echo "backup done"
      '';
      serviceConfig.Type = "oneshot";
    };

    systemd.timers.your_app_backup = {
      wantedBy = [ "timers.target" ];
      partOf = [ "your_app_backup.service" ];
      timerConfig.OnCalendar = "minutely";
    };
  };
}
