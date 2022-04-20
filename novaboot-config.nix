{ config, pkgs, lib, nixpkgsPath, ... }:
{
  # Override the mkForce in configuration.nix
  boot.supportedFilesystems = lib.mkOverride 45 [ "vfat" "nfs" ];

  novaboot.nfs.server = {
    # Can also be set using nfsPrefix= and nfsOptions= on kernel command line.
    # address = "1.2.3.4";
    # rootPath = "/";
    options = [ "tcp" "nolock" ];
  };

  nix.settings.trusted-users = [ "root" "nixos" ];

  # building nixos manual takes long time
  documentation.nixos.enable = false; 
}