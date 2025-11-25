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
    self,
    nixpkgs,
    home-manager,
    nixvim,
    ...
  }: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
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
