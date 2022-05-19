{ patchPkgs ? false,
  pkgs ? import ./nixpkgs.nix {patched = patchPkgs;} {}
}:

let
  nixpkgsPath = pkgs.path;
  fromPkgs = path: pkgs.path + "/${path}";
  evalConfig = import (fromPkgs "nixos/lib/eval-config.nix");
  buildConfig = { system, configuration ? {}, extraModules ? [] }:
    evalConfig {
      specialArgs = {
        inherit nixpkgsPath;
      };
      modules= [
          (./. + "/${system}.nix")
          configuration
      ] ++ extraModules;
    };
in
{
  aarch64-linux.novaboot = (buildConfig {
      system = "aarch64-linux";
      configuration = (fromPkgs "nixos/modules/installer/cd-dvd/system-tarball-novaboot.nix");
      extraModules = [ ./novaboot-config.nix ];
    }).config.system.build.novabootTarball;
}
