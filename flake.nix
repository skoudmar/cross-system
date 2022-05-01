{
  description = "A template that shows all standard flake outputs";

  # Inputs
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs

  # The master branch of the NixOS/nixpkgs repository on GitHub.
  inputs.nixpkgs.url = "github:skoudmar/nixpkgs/novaboot";
  # inputs.nixpkgs.url = "/home/martin/proj/nixos/nixpkgs";

  # Work-in-progress: refer to parent/sibling flakes in the same repository
  # inputs.c-hello.url = "path:../c-hello";

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
