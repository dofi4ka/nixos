{
  pkgs,
  lib,
  ...
}: let
  src = pkgs.fetchFromGitHub {
    owner = "cachebag";
    repo = "nmrs";
    rev = "4e024ce1f30c43c50be12153a8f854e9dc1a007c";
    sha256 = "1s6lqpp3fvnk49jbn3zjh66vf5xd93lwrjy5z3fvmg9vqc7hirby";
  };
  rustPlatform = pkgs.makeRustPlatform {
    cargo = pkgs.cargo;
    rustc = pkgs.rustc;
  };
in
  rustPlatform.buildRustPackage {
    pname = "nmrs";
    version = "1.3.5";

    inherit src;

    cargoHash = "sha256-2+EaId/l0WIf93e1gcBu7nhF2yxxMYg8bFSAIYLlo8Q=";

    nativeBuildInputs = with pkgs;
      [
        pkg-config
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        pkgs.wrapGAppsHook4
      ];

    buildInputs = lib.optionals pkgs.stdenv.hostPlatform.isLinux (with pkgs; [
      glib-networking
      libxkbcommon
      wayland
      glib
      gobject-introspection
      gtk4
      libadwaita
    ]);

    doCheck = false;
    doInstallCheck = true;

    meta = with lib; {
      description = "Wayland-native frontend for NetworkManager.";
      homepage = "https://github.com/dofi4ka/nmrs";
      license = licenses.mit;
      maintainers = [];
      mainProgram = "nmrs";
      platforms = platforms.linux ++ platforms.darwin;
    };
  }
