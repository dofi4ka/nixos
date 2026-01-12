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

    prismlauncher

    fzf
    eza
    yazi
    zoxide
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

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

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
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Telescope find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Telescope live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options.desc = "Telescope buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<cr>";
        options.desc = "Telescope help tags";
      }
      {
        mode = "n";
        key = "<leader>ee";
        action = "<cmd>NvimTreeToggle<cr>";
        options.desc = "NvimTree toggle";
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
      nvim-tree.enable = true;
      telescope.enable = true;
      wakatime.enable = true;
      trouble.enable = true;
      web-devicons.enable = true;
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
        keymaps = {
          diagnostic = {
            "<leader>j" = "goto_next";
            "<leader>k" = "goto_prev";
          };
          lspBuf = {
            K = "hover";
            gD = "references";
            gd = "definition";
            gi = "implementation";
            gt = "type_definition";
          };
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
        settings = {
          ensure_installed = [
            "nix"
            "yaml"
            "rust"
            "python"
            "elixir"
            "eex"
            "heex"
            "java"
          ];
          highlight = {
            enable = true;
          };
        };
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
