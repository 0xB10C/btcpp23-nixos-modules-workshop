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
      # FIXME: Task 2.1: Declare options for the your_app service
      # use mkOption ! 

      port = mkOption {
        type = types.port;
        default = null;
        example = 8282;
        description = lib.mdDoc "The webserver port your_app is listening on.";
      };

      rpc = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          example = "localhost";
          description = lib.mdDoc "The Bitcoin Core RPC host to use.";
        };

        port = mkOption {
          type = types.port;
          default = 8332;
          example = 18884;
          description = lib.mdDoc "The Bitcoin Core RPC port to use.";
        };

        password = mkOption {
          type = types.str;
          default = null;
          description = lib.mdDoc "The Bitcoin Core RPC password to use. This will be world-readable!";
        };

        user = mkOption {
          type = types.str;
          default = null;
          example = "username";
          description = lib.mdDoc "The Bitcoin Core RPC username to use.";
        };
      }; 
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
          --rpc-host ${cfg.rpc.host} \
          --rpc-port ${toString cfg.rpc.port} \
          --rpc-user ${cfg.rpc.user} \
          --rpc-password ${cfg.rpc.password} \
          server ${toString cfg.port}
        '';
        # FIXME: Task 3.3: your_app hardening
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        MemoryDenyWriteExecute = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectControlGroups = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        RestrictNamespaces = true;
        LockPersonality = true;
        PrivateUsers = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
      };
    };
  };
}
