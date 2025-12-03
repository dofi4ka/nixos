{
  description = "NixOS from Scratch";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    ...
  }: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/common/configuration.nix
        ./hosts/desktop/configuration.nix
        ./hosts/desktop/hardware-configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [nixvim.homeModules.nixvim];
            extraSpecialArgs = {inherit nixvim;};
            users.dofi4ka = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };

    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/common/configuration.nix
        ./hosts/laptop/hardware-configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [nixvim.homeModules.nixvim];
            extraSpecialArgs = {inherit nixvim;};
            users.dofi4ka = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
