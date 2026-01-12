{
  config,
  pkgs,
  lib,
  firefox-addons,
  ...
}: let
  dotfiles = [
    ".gitmessage"
    ".config/kitty"
    ".config/waybar"
    ".config/niri"
  ];
  channel = "25.11";
in {
  home.username = "dofi4ka";
  home.homeDirectory = "/home/dofi4ka";
  home.stateVersion = channel;
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
    settings = {
      user = {
        email = "dofi4ka@yandex.ru";
        name = "dofi4ka";
      };
      commit = {
        template = "${config.home.homeDirectory}/.gitmessage";
        verbose = true;
      };
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  programs.librewolf = {
    enable = true;
    policies = {
      BlockAboutConfig = true;
      DefaultDownloadDirectory = "\${home}/Downloads";
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          default_area = "navbar";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "foxyproxy@eric.h.jung" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/foxyproxy-standard/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };

    settings = {
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "extensions.quarantinedDomains.enabled" = false;
    };

    profiles.default = {
      id = 0;
      isDefault = true;
      name = "default";

      settings = {
        "extensions.autoDisableScopes" = 0;
      };

      userChrome = ''
        #TabsToolbar, #sidebar-main  {
          display: none !important;
        }

        #sidebar-box {
          padding-block-end: none !important;
        }

        #sidebar {
          border-radius: none !important;
          box-shadow: none !important;
          outline: none !important;
        }
      '';

      search = {
        default = "ddg";
        privateDefault = "ddg";
        force = true;

        order = [
          "ddg"
          "yandex"
          "perplexity"
          "nix-packages"
          "nix-options"
          "nix-home-manager-options"
          "nixos-wiki"
        ];

        engines = {
          yandex = {
            name = "Yandex";
            urls = [{template = "https://yandex.ru/search?text={searchTerms}";}];
            iconMapObj."16" = "https://yandex.ru/favicon.ico";
            definedAliases = ["@ya"];
          };

          nix-packages = {
            name = "Nix Packages";
            urls = [{template = "https://search.nixos.org/packages?channel={channel}&query={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };

          nix-options = {
            name = "Nix Options";
            urls = [{template = "https://search.nixos.org/options?channel={channel}&query={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@no"];
          };

          nix-home-manager-options = {
            name = "Nix Home Manager Options";
            urls = [{template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=release-{channel}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@nho"];
          };

          nixos-wiki = {
            name = "NixOS Wiki";
            urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@nw"];
          };
        };
      };

      extensions = {
        packages = with firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          bitwarden
          sidebery
          foxyproxy-standard
        ];
        force = true;
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion = {
      enable = true;
      strategy = ["history"];
    };
    defaultKeymap = "viins";

    history = {
      append = true;
      extended = true;
      share = true;
      size = 10000;
    };

    shellAliases = {
      f = "yazi";
      nixc = "cd ~/.nixos && nvim .";
      nrsl = "sudo nixos-rebuild --flake ~/.nixos#laptop switch";
      nrsd = "sudo nixos-rebuild --flake ~/.nixos#desktop switch";
    };

    siteFunctions = {
      mkcd = ''
        mkdir --parents "$1" && cd "$1"
      '';
      rndcat = ''
        kitten icat $(curl -s https://api.thecatapi.com/v1/images/search | jq -r '.[0].url')
      '';
      rndcatloop = ''
        local delay="$\{1:-5}"
        while :; do
          tmp="$(mktemp)";
          curl -s $(curl -s https://api.thecatapi.com/v1/images/search | jq -r '.[0].url') -o "$tmp";
          clear;
          kitten icat "$tmp";
          rm -f "$tmp";
          sleep "$delay";
        done
      '';
    };
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
