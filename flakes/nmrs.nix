{
  pkgs,
  lib,
  ...
}: let
  src = pkgs.fetchFromGitHub {
    owner = "dofi4ka";
    repo = "nmrs";
    rev = "d7dcc35f90ec8c08b2cb4777308432d943c6b98d";
    sha256 = "sha256-2dcV20fkFOBkBu2HNNZxQZq0nCzd8qwiyxcwmOicTYs=";
  };
  rustPlatform = pkgs.makeRustPlatform {
    cargo = pkgs.cargo;
    rustc = pkgs.rustc;
  };
in
  rustPlatform.buildRustPackage {
    pname = "nmrs";
    version = "0.1.0-beta";

    inherit src;

    cargoHash = "sha256-bGfDO3kLwecOnXMr+L1o4nUytx8hQGqdNOmOZHnG3/Y=";

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
