{ stdenv, pkgs, rustPlatform, ... }:

  rustPlatform.buildRustPackage rec {
    name = "your_app";

    src = ./.;

    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    # Running tests increases the build time. We don't want that for the workshop.
    doCheck = false;

    meta = with stdenv.lib; {
      description = "A demo app for the NixOS modules workshop at BTC++ 23 Berlin.";
    };
  }

