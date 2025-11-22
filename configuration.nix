{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  virtualisation.docker.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  services.greetd = {
	enable = true;
	settings.default_session = {
		command = "niri-session";
		user = "dofi4ka";
	};
  };

  systemd.user.services.xwayland-satellite = {
	description = "XWayland Satellite for X-compatability";

	wantedBy = [ "default.target" ];

	serviceConfig = {
		ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
		Restart = "always";
	};
  };

  systemd.services.amnezia-vpn = {
	description = "AmneziaVPN background service";

	wantedBy = [ "multi-user.target" ];
	after = [ "network-online.target" ];
	wants = [ "network-online.target" ];

	serviceConfig = {
		Type = "simple";
		ExecStart = "${pkgs.amnezia-vpn}/bin/AmneziaVPN-service";
		Restart = "on-failure";
		User = "root";
	};
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.dofi4ka = {
    isNormalUser = true;
    description = "dofi4ka";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    ];
  };

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = ["nvidia"];
  
  hardware = {
    graphics.enable = true;
    nvidia = {
      open = false;
      nvidiaSettings = true;    
      package = config.boot.kernelPackages.nvidiaPackages.latest;
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

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    steam-run
    telegram-desktop
    neovim
    amnezia-vpn
    fastfetch
    wget
    appimage-run
    git
    btop
    nemo
    niri
    alacritty
    waybar
    fuzzel
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  system.stateVersion = "25.05";
}
