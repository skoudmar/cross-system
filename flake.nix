{
  description = "The novaboot NixOS image";

  inputs.nixpkgs.url = "github:skoudmar/nixpkgs/novaboot";

  outputs = all@{ self, nixpkgs, ... }: {

    # Utilized by `nix build .`
    defaultPackage.x86_64-linux = (nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixpkgs.nixosModules.novabootTarball
        ({lib, pkgs, ...}:{
          nixpkgs.crossSystem = {
            system = "aarch64-linux";
          };
          boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
        })
        (import ./novaboot-config.nix)
        nixpkgs.nixosModules.profileMinimal
        nixpkgs.nixosModules.profileInstallationDevice
      ];
    }).config.system.build.novabootTarball;
    
  };
}
