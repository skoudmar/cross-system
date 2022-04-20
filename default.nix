{ patchPkgs ? true,
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
    }
  ;
in
{
  armv6l-linux = {
    sdImage = (buildConfig {
      system = "armv6l-linux";
      configuration = (fromPkgs "nixos/modules/installer/sd-card/sd-image-raspberrypi.nix");
    }).config.system.build.sdImage;
  };
  armv7l-linux = {
    isoImage = (buildConfig {
      system = "armv7l-linux";
      configuration = (fromPkgs "nixos/modules/installer/cd-dvd/installation-cd-minimal.nix");
    }).config.system.build.isoImage;
    sdImage = (buildConfig {
      system = "armv7l-linux";
      configuration = (fromPkgs "nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform-installer.nix");
    }).config.system.build.sdImage;
  };
  aarch64-linux = {
    isoImage = (buildConfig {
      system = "aarch64-linux";
      configuration = (fromPkgs "nixos/modules/installer/cd-dvd/installation-cd-minimal.nix");
    }).config.system.build.isoImage;
    sdImage = (buildConfig {
      system = "aarch64-linux";
      configuration = (fromPkgs "nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix");
    }).config.system.build.sdImage;
    novaboot = (buildConfig {
      system = "aarch64-linux";
      configuration = (fromPkgs "nixos/modules/installer/cd-dvd/system-tarball-novaboot.nix");
      extraModules = [ ./novaboot-config.nix ];
    }).config.system.build.novabootTarball;
  };
}
