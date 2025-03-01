{
	description = "Flakeno.1";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
		home-manager.url = "github:nix-community/home-manager/release-24.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = {self, nixpkgs,home-manager, ...}:
		let
		   lib = nixpkgs.lib;
		   system = "x86_64-linux";
		   pkgs = nixpkgs.legacyPackages.${system};
		in { 
		nixosConfigurations = {
			nixos-comp = lib.nixosSystem {
				inherit system;
				modules = [./configuration.nix];		
			};
		};

		homeConfigurations = {
			nishant = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [./home.nix];
			};
		};
	};
}
