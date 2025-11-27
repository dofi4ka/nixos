{
  config,
  pkgs,
  lib,
  ...
}: let
  dotfiles = [
    ".zshrc"
    ".gitmessage"
    ".config/kitty"
    ".config/waybar"
    ".config/niri"
  ];
in {
  home.username = "dofi4ka";
  home.homeDirectory = "/home/dofi4ka";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    tree
    waybar
    pavucontrol
    (import flakes/cursor.nix {inherit pkgs lib;})
    ansible
    wl-clipboard
  ];

  home.file =
    builtins.listToAttrs
    (
      map
      (path: {
        name = "${path}";
        value = {
          source = ./dotfiles/${path};
        };
      })
      dotfiles
    );

  programs.git = {
    enable = true;
    userName = "dofi4ka";
    userEmail = "dofi4ka@yandex.ru";
    extraConfig = {
      init.defaultBranch = "main";
      commit.template = "${config.home.homeDirectory}/.gitmessage";
      core.editor = "nvim";
    };
  };

  programs.zsh = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    baseIndex = 1;
    mouse = true;
    clock24 = true;
    historyLimit = 50000;
  };

  programs.nixvim = {
    enable = true;
    extraPackages = with pkgs; [
      alejandra
      gcc
      yamlfmt
      rustfmt
      cargo
      rustc
    ];
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };
    plugins = {
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          yamlls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = [
              "alejandra"
            ];
            yaml = [
              "yamlfmt"
            ];
            rust = [
              "rustfmt"
            ];
          };
          format_on_save = {
            timeout_ms = 200;
            lsp_fallback = true;
          };
        };
      };
      treesitter = {
        enable = true;
        settings.ensure_installed = [
          "nix"
          "yaml"
          "rust"
        ];
      };
    };
    colorschemes.tokyonight.enable = true;
  };
}
