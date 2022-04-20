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
    defaultPackage.x86_64-linux = (import ./default.nix {pkgs = nixpkgs;}).aarch64-linux.novaboot;
    
  };
}
