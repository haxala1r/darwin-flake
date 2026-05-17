{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    godot-darwin.url = "github:haxala1r/godot-darwin-flake";
    godot-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, godot-darwin, home-manager }:
  let
    configuration = { pkgs, ... }: {
      environment.systemPackages = with pkgs;
        [ vim librewolf utm btop
          godot-darwin.packages.aarch64-darwin.default
        ];
      nixpkgs.config.allowUnfree = true;
      nix.enable = false; # I manage nix myself      
      # Enable/disable sshd
      services.openssh.enable = false;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      users.users.haxala1r = {
        name = "haxala1r";
        home = "/Users/haxala1r";
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."Emins-Macbook-Air" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
	      home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.haxala1r = import ./home.nix;
        }
      ];
    };
  };
}
