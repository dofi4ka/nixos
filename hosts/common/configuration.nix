{pkgs, ...}: {
  services.fprintd.enable = true;

  virtualisation = {
    docker = {
      enable = true;

      daemon.settings = {
        dns = ["8.8.8.8" "8.8.4.4" "1.1.1.1"];
        dns-opts = ["use-vc"];
      };
    };

    podman = {
      enable = true;
      # dockerCompat = true; # Optional, for Docker socket emulation
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  programs.dconf.enable = true;

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

  services.blueman.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "niri-session";
      user = "dofi4ka";
    };
  };

  systemd.user.services.xwayland-satellite = {
    description = "XWayland Satellite for X-compatability";

    wantedBy = ["default.target"];

    serviceConfig = {
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      Restart = "always";
    };
  };

  systemd.services.amnezia-vpn = {
    description = "AmneziaVPN background service";

    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.amnezia-vpn}/bin/AmneziaVPN-service";
      Restart = "on-failure";
      User = "root";
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

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.dofi4ka = {
      isNormalUser = true;
      description = "dofi4ka";
      extraGroups = ["networkmanager" "wheel" "docker"];
      shell = pkgs.zsh;
    };
  };

  programs.firefox.enable = true;
  programs.nix-ld.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    steam-run
    telegram-desktop
    amnezia-vpn
    fastfetch
    wget
    git
    cassette
    btop
    nemo
    niri
    kitty
    waybar
    fuzzel
    jq
    podman
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  system.stateVersion = "25.05";
}
