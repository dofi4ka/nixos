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
    (import flakes/nmrs.nix {inherit pkgs lib;})
    ansible
    wl-clipboard
    uv
    nodejs
    pnpm
    qbittorrent
    anydesk
    javaPackages.compiler.temurin-bin.jdk-21
    tesseract
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
      commit.verbose = true;
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
    keymaps = [
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics (Trouble)";
      }
    ];
    enable = true;
    extraPackages = with pkgs; [
      alejandra
      gcc
      yamlfmt
      rustfmt
      cargo
      rustc
      ruff
      elixir
      erlang
      google-java-format
    ];
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };
    plugins = {
      wakatime.enable = true;
      trouble = {
        enable = true;
      };
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
          pyright.enable = true;
          elixirls.enable = true;
          jdtls.enable = true;
        };
      };
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = ["alejandra"];
            yaml = ["yamlfmt"];
            rust = ["rustfmt"];
            py = ["ruff"];
            elixir = ["mix"];
            java = ["google-java-format"];
          };
          format_on_save = {
            timeout_ms = 2000;
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
          "python"
          "elixir"
          "eex"
          "heex"
          "java"
        ];
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          mapping = {
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
          };
          sources = [
            {name = "nvim_lsp";}
            {name = "buffer";}
            {name = "path";}
          ];
        };
      };
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
    };
    colorschemes.tokyonight.enable = true;
  };
}
