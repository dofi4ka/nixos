{ config, pkgs, ... }:

{
	home.username = "dofi4ka";
	home.homeDirectory = "/home/dofi4ka";
	home.stateVersion = "25.05";
	home.packages = with pkgs; [
		tree
		waybar
		pavucontrol
	];

	home.file.".config/waybar".source = ./waybar;

	programs.git = {
		enable = true;
		userName = "dofi4ka";
		userEmail = "dofi4ka@yandex.ru";
		extraConfig.init.defaultBranch = "main";
	};

	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo I use nixos, btw";
		};
	};
}
