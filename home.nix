{
  config,
  pkgs,
  lib,
  firefox-addons,
  ...
}: let
  channel = "25.11";

  GTK_THEME_NAME = "Graphite";
  GTK_CURSOR_NAME = "graphite-dark";
  GTK_ICONS_NAME = "Fluent-dark";
  GTK_FONT = "DejaVuSans";
  GTK_DARK = true;

  GTK_FONTS_PACKAGE = pkgs.dejavu_fonts;
  GTK_THEME_PACKAGE = pkgs.graphite-gtk-theme;
  GTK_CURSOR_PACKAGE = pkgs.graphite-cursors;
  GTK_ICONS_PACKAGE = pkgs.fluent-icon-theme;
in {
  home = {
    username = "dofi4ka";
    homeDirectory = "/home/dofi4ka";
    stateVersion = channel;
    packages = with pkgs; [
      # linuxKernel.packages.linux_hardened.amneziawg
      amneziawg-go
      amneziawg-tools
      tree
      waybar
      pavucontrol
      (import flakes/cursor.nix {inherit pkgs lib;})
      ansible
      wl-clipboard
      uv
      nodejs
      pnpm
      qbittorrent
      javaPackages.compiler.temurin-bin.jdk-21
      tesseract

      jq
      btop
      gnumake

      swww
      leetcode-cli

      prismlauncher

      telegram-desktop
      libreoffice
      nemo
    ];

    file.".gitmessage".source = ./dotfiles/.gitmessage;
    file.".config/kitty".source = ./dotfiles/.config/kitty;
    file.".config/waybar/style.css".source = ./dotfiles/.config/waybar/style.css;
    file.".config/waybar/config.jsonc".source = ./dotfiles/.config/waybar/config.jsonc;
    file.".config/waybar/scripts/vpn-up".text = "sudo ${pkgs.amneziawg-tools}/bin/awg-quick up wg0";
    file.".config/waybar/scripts/vpn-down".text = "sudo ${pkgs.amneziawg-tools}/bin/awg-quick down wg0";
    file.".config/niri".source = ./dotfiles/.config/niri;
    file."wallpapers".source = ./dotfiles/wallpapers;

    pointerCursor = {
      enable = true;
      gtk.enable = true;
      name = GTK_CURSOR_NAME;
      package = GTK_CURSOR_PACKAGE;
    };

    sessionVariables = {
      GTK_THEME = GTK_THEME_NAME;

      EDITOR = "nvim";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  gtk = {
    enable = true;

    colorScheme =
      if GTK_DARK
      then "dark"
      else "light";
    font = {
      name = GTK_FONT;
      package = GTK_FONTS_PACKAGE;
    };
    theme = {
      name = GTK_THEME_NAME;
      package = GTK_THEME_PACKAGE;
    };
    iconTheme = {
      name = GTK_ICONS_NAME;
      package = GTK_ICONS_PACKAGE;
    };
    cursorTheme = {
      name = GTK_CURSOR_NAME;
      package = GTK_CURSOR_PACKAGE;
    };

    gtk4 = {
      enable = true;
      theme = {
        name = GTK_THEME_NAME;
        package = GTK_THEME_PACKAGE;
      };
    };
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
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };

    profiles.default = {
      id = 0;
      isDefault = true;
      name = "default";

      settings = {
        "extensions.autoDisableScopes" = 0;
      };

      userChrome = ''
        /* Defatul horizontal tabs */
        #TabsToolbar,

        /* Sidebar menu with links. */
        #sidebar-main,

        /* UI elements to the left of urlbar. */
        #sidebar-button, #back-button,
        #forward-button, #stop-reload-button,
        #customizableui-special-spring1,

        /* UI elements to the right of urlbar. */
        #customizableui-special-spring2,

        /* Accounts button */
        #fxa-toolbar-menu-button

        {
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
            urls = [{template = "https://search.nixos.org/packages?channel=${channel}&query={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };

          nix-options = {
            name = "Nix Options";
            urls = [{template = "https://search.nixos.org/options?channel=${channel}&query={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@no"];
          };

          nix-home-manager-options = {
            name = "Nix Home Manager Options";
            urls = [{template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=release-${channel}";}];
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
      # Use same path as in sudoerc, so it can be executed without password
      awg-quick = "sudo ${pkgs.amneziawg-tools}/bin/awg-quick";
    };

    siteFunctions = {
      mkcd = ''
        mkdir --parents "$1" && cd "$1"
      '';
      rndcat = ''
        kitten icat $(curl -s https://api.thecatapi.com/v1/images/search | jq -r '.[0].url')
      '';
      rndcatloop = ''
        while :; do
          tmp="$(mktemp)";
          curl -s $(curl -s https://api.thecatapi.com/v1/images/search | jq -r '.[0].url') -o "$tmp";
          clear;
          kitten icat "$tmp";
          rm -f "$tmp";
          sleep 5;
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

  programs.nixvim = {lib, ...}: {
    keymaps = [
      # Move around windows using <A-[hjkl]> keys
      {
        mode = "n";
        key = "<A-h>";
        action = "<C-w>h";
        options.desc = "Move to the window left";
      }
      {
        mode = "n";
        key = "<A-l>";
        action = "<C-w>l";
        options.desc = "Move to the window right";
      }
      {
        mode = "n";
        key = "<A-j>";
        action = "<C-w>j";
        options.desc = "Move to the window below";
      }
      {
        mode = "n";
        key = "<A-k>";
        action = "<C-w>k";
        options.desc = "Move to the window up";
      }
      # Move around windows using <A-[hjkl]> keys in insert mode
      {
        mode = "i";
        key = "<A-h>";
        action = "<C-\\><C-n><C-w>h";
        options.desc = "Move to the window left";
      }
      {
        mode = "i";
        key = "<A-l>";
        action = "<C-\\><C-n><C-w>l";
        options.desc = "Move to the window right";
      }
      {
        mode = "i";
        key = "<A-j>";
        action = "<C-\\><C-n><C-w>j";
        options.desc = "Move to the window below";
      }
      {
        mode = "i";
        key = "<A-k>";
        action = "<C-\\><C-n><C-w>k";
        options.desc = "Move to the window up";
      }
      # Move around windows using <A-[hjkl]> keys in terminal mode
      {
        mode = "t";
        key = "<A-h>";
        action = "<C-\\><C-n><C-w>h";
        options.desc = "Move to the window left";
      }
      {
        mode = "t";
        key = "<A-l>";
        action = "<C-\\><C-n><C-w>l";
        options.desc = "Move to the window right";
      }
      {
        mode = "t";
        key = "<A-j>";
        action = "<C-\\><C-n><C-w>j";
        options.desc = "Move to the window below";
      }
      {
        mode = "t";
        key = "<A-k>";
        action = "<C-\\><C-n><C-w>k";
        options.desc = "Move to the window up";
      }
      {
        mode = "t";
        key = "<A-Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }
      {
        mode = "n";
        key = "<leader>w";
        action = "<C-w>";
      }
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>terminal<cr>";
        options.desc = "Open a terminal";
      }
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
      {
        mode = "n";
        key = "<leader>gD";
        action = "<cmd>Telescope lsp_definitions<cr>";
        options.desc = "Telescope definition";
      }
      {
        mode = "n";
        key = "<leader>gr";
        action = "<cmd>Telescope lsp_references<cr>";
        options.desc = "Telescope lsp references";
      }
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>Telespoce lsp_document_symbols<cr>";
        options.desc = "Telescope document symbols";
      }
      {
        mode = "n";
        key = "<leader>gS";
        action = "<cmd>Telescope lsp_workspace_symbols<cr>";
        options.desc = "Telescope lsp workspace symbols";
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
      black
      erlang
      google-java-format
      nodejs
      typescript-language-server
      prettier
      clang
      astro-language-server
    ];
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      clipboard = "unnamedplus";
    };
    globals.mapleader = " ";
    plugins = {
      mini-icons.enable = true;
      mini-ai.enable = true;
      mini-bracketed.enable = true;
      mini-comment.enable = true;
      mini-completion.enable = true;
      mini-cursorword.enable = true;
      mini-diff.enable = true;

      ts-comments.enable = true;
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
          jdtls.enable = true;
          ts_ls.enable = true;
          clangd.enable = true;
          astro.enable = true;
        };
        keymaps = {
          diagnostic = {
            "<leader>j" = "goto_next";
            "<leader>k" = "goto_prev";
          };
          lspBuf = {
            K = "hover";
            # gr = "references";
            gd = "definition";
            # gi = "implementation";
            # gt = "type_definition";
            "<leader>lr" = "rename";
            "<leader>lc" = "code_action";
            "<leader>lf" = "format";
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
            python = ["black"];
            java = ["google-java-format"];
            javascript = ["prettier"];
            typescript = ["prettier"];
            javascriptreact = ["prettier"];
            typescriptreact = ["prettier"];
            astro = ["prettier"];
            cpp = ["clang-format"];
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
            "java"
            "javascript"
            "typescript"
            "cpp"
            "css"
            "astro"
          ];
          highlight = {
            enable = true;
          };
        };
      };
    };
    colorschemes.catppuccin.enable = true;
  };
}
