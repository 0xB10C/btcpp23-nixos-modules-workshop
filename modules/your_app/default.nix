{ config, pkgs, lib, ... }:

with lib;

let
  pkg = pkgs.callPackage ../../pkgs/your_app {};
  cfg = config.services.your_app;
in
{
  # imports = [ paths of other modules ];

  options = {
    # option declarations

    services.your_app = {
      enable = mkEnableOption "YOUR_APP";

      port = mkOption {
        type = types.port;
        default = 4242;
        example = 4242;
        description = "The Bitcoin Core RPC server port to connect to";
      };

      bitcoin = {
        rpcHost = mkOption {
          type = types.str;
          default = "localhost";
          example = "127.0.0.1";
          description = "The Bitcoin Core RPC server host to connect to";
        };

        rpcPort = mkOption {
          type = types.port;
          default = 8334;
          example = 8334;
          description = "The Bitcoin Core RPC server port to connect to";
        };

        rpcUser = mkOption {
          type = types.str;
          default = null;
          example = "user";
          description = "The Bitcoin Core RPC user used to authenticate to the RPC server";
        };

        rpcPassword = mkOption {
          type = types.str;
          default = null;
          example = "password";
          description = "The Bitcoin Core RPC password used to authenticate to the RPC server";
        };
      };

    };

  };

  # Option definitions.
  # `mkIf` makes the following option definitions conditional on the module being enabled.
  # See https://nixos.org/manual/nixos/stable/#sec-option-definitions-delaying-conditionals
  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [ cfg.port ];


    # We define the systemd service called your_app.
    # NixOS takes care of creating the necessary service files.
    systemd.services.your_app = {
      description = "your_app server daemon";

      # TODO:
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];

      # TODO:
      serviceConfig = {
        ExecStart = ''${pkg}/bin/your_app \
          --rpc-host ${cfg.bitcoin.rpcHost} \
          --rpc-port ${toString cfg.bitcoin.rpcPort} \
          --rpc-user ${cfg.bitcoin.rpcUser} \
          --rpc-password ${cfg.bitcoin.rpcPassword} \
          server ${toString cfg.port}
        '';

        # very basic hardening
        PermissionsStartOnly = true;
        MemoryDenyWriteExecute = true;

        # TODO:
        DynamicUser = true;
      };

    };


    systemd.services.your_app_backup = {
      description = "your_app server backup";
      after = [ "network-online.target" ];
      script = ''
      echo "starting backup..."
      ${pkg}/bin/your_app \
        --rpc-host ${cfg.bitcoin.rpcHost} \
        --rpc-port ${toString cfg.bitcoin.rpcPort} \
        --rpc-user ${cfg.bitcoin.rpcUser} \
        --rpc-password ${cfg.bitcoin.rpcPassword} \
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
