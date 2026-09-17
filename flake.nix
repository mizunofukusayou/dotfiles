{
  description = "dotfiles configuration of mizunofukusayou";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    lazyvim.url = "github:pfassina/lazyvim-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      lazyvim,
      ...
    }:
    let
      darwinHosts = {
        "mizunofukusayounoMacBook-Air" = "mizunofukusayou";
        "mizufukunoMacBook-Air" = "mizufuku";
      };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      darwinConfigurations = builtins.mapAttrs (
        hostname: userName:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit userName;
            inherit self;
            inherit lazyvim;
          };
          modules = [
            ./nix-darwin/configuration.nix
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
          ];
        }
      ) darwinHosts;

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            go-task
          ];
        };
      });
    };
}
