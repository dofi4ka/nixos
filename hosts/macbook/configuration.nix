{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  programs.dconf.enable = true;
  users = {
    defaultUserShell = pkgs.zsh;
    users.dofi4ka = {
      isNormalUser = true;
      description = "dofi4ka";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  services = {
    blueman.enable = true;
    greetd = {
      enable = true;
      settings.default_session = {
        command = "niri-session";
        user = "dofi4ka";
      };
    };
    pulseaudio = {
      enable = false;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    fprintd = {
      enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    sudo = {
      enable = true;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.amneziawg-tools}/bin/awg-quick";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.amneziawg-tools}/bin/awg-quick down";
              options = ["NOPASSWD"];
            }
          ];
          groups = ["wheel"];
        }
      ];
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  systemd.user.services.xwayland-satellite = {
    description = "XWayland Satellite for X-compatability";

    wantedBy = ["default.target"];

    serviceConfig = {
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      Restart = "always";
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    fastfetch
    wget
    git
    niri
    kitty
    waybar
    fuzzel
  ];
  system.stateVersion = "25.11";
}
