{
  pkgs,
  lib,
  ...
}: let
  getCursorAppImage = {
    url,
    sha256,
    version,
  }:
    pkgs.appimageTools.wrapType2 {
      pname = "cursor";
      inherit version;
      src = pkgs.fetchurl {
        inherit url sha256;
      };
      extraPkgs = pkgs: with pkgs; [];
    };
in
  getCursorAppImage {
    version = "2.1.20";
    url = "https://downloads.cursor.com/production/a8d8905b06c8da1739af6f789efd59c28ac2a680/linux/x64/Cursor-2.1.20-x86_64.AppImage";
    sha256 = "180xf2mx49vlkxzmavv49jrgfsxzvw4m4rz9876g4p350864mzjp";
  }
