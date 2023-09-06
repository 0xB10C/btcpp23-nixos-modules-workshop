# This file is imported by vm.nix and rebuild.nix. Declare services here.

{ pkgs, modulesPath, config, ... }:

let
  yourAppPort = 4242;
in
{

  ## Task 1

  imports = [
    ./modules/your_app
  ];

  services.bitcoind."regtest" = {
    enable = true;
    rpc = {
      port = 18444;
      users.workshop = {
        name = "workshop";
        # hashed password can be generated with https://github.com/bitcoin/bitcoin/blob/master/share/rpcauth/rpcauth.py
        # or https://jlopp.github.io/bitcoin-core-rpc-auth-generator/
        # Here, the password is "btcpp23berlin".
        passwordHMAC = "261106eacc7b4ff02628fbda556d65ec$bdc62ae101fbe7948c44b5475e2b56d046e326ce5d4f81b55e0861a66801226b";
      };
    };
    extraConfig = ''
      regtest=1
    '';
  };

  ## Task 2

  services.your_app = {
    enable = true;
    port = yourAppPort;
    bitcoin = {
      rpcHost = "localhost";
      rpcPort = config.services.bitcoind."regtest".rpc.port;
      rpcUser = "workshop";
      rpcPassword = "btcpp23berlin";
    };
  };

  

}
