{ config, pkgs, lib, nixpkgsPath, ... }:
{
  # Override the mkForce in configuration.nix
  boot.supportedFilesystems = lib.mkOverride 45 [ "vfat" "nfs" ];

  novaboot.nfs.server = {
    # Fill these params
    address = "1.2.3.4";
    rootPath = "/nfsroot";
    options = [ "nolock" "tcp" "v3" ];
  };
}