{
  description =
    "ilosrim nix environment: NixOS, Home Manager and Nixvim";
  inputs = {
    # nix derivations
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11"; # stable channel
    };
    nixpkgs-unstabel = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix darwin
    # darwin = {
    #  url = "github:lnl7/nix-darwin";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    # nixified vim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # tree-sitter-rescript
    ts-rescript = {
      url = "github:nkrkv/tree-sitter-rescript";
      flake = false;
    };
  };

  # TODO: for each system configuration. 

  outputs = inputs@{ nixpkgs, home-manager, darwin, nixvim, ... }:
    let
      # Define user 
      user = {
        name = "ilosrim";
        linux = "x86_64-linux";
        darwin = "x86_64-darwin";
      };

      # Define pkgs 
      pkgs = system:
        import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };

      # Define Func for Home Manager configuration
      mkHomeConfig = system: username:
          home-manager.lib.homeManagerConfiguration {
            pkgs = pkgs system;
            modules = [
              ./modules/home-manager
              {
                home.username = username;
                home.homeDirectory = "/home/${username}";
              }

              nixvim.homeManagerModules.nixvim
            ];
          }

      # Define Func for NixOS configuration
      mkNixosConfig = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./nixos/configuration.nix ];
      };

      # Define Func for Nixvim Standalone
      mkNixvim = system:
        let nixvim' = nixvim.legacyPackages.${system};
        in nixvim'.makeNixvimWithModule {
          pkgs = pkgs system;
          module = ./modules/nixvim/config.nix;
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            # inherit (inputs) foo;
          };
        };
    in {
    
      # standalone linux home manager 
      homeConfigurations.${user.name} = mkHomeConfig user.linux user.name;

      # nixos + home manager
      nixosConfigurations.${user.name} = mkNixosConfig;

      # standalone nixvim 
      nixvim = mkNixvim;
    };
}
