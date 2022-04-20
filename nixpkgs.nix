{
  patched ? false,
  buildSystem ? builtins.currentSystem
}:
let 
  pkgsGit = import (builtins.fetchGit {
    name = "skoudmar-nixpkgs";
    url = "https://github.com/skoudmar/nixpkgs.git";
    ref = "novaboot";
  });
  
  pkgs = pkgsGit {};
  systemFile = pkgs.writeTextFile {
    name = "system.nix";
    text = ''
      {
        build = "${buildSystem}";
        host = builtins.currentSystem;
      }
    '';
  };

  patchedPkgs = pkgs.runCommandLocal 
    "nixpkgs-patched"
    {
      # env
      pkgs = pkgs.path;
      inherit systemFile;
    }
    ''
      mkdir -p $out
      cp $systemFile $out/system.nix
      cp -a $pkgs/. $out/
    '';
in
if patched
then import patchedPkgs
else pkgsGit

