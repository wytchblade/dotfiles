{
  description = "main flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
    	url = "github:nix-community/home-manager";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
  let 
	system = "x86_64-linux";
	pkgs = import nixpkgs {
		inherit system;
		config = { allowUnfree = true;};
	};
  	lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
    	wytchblade = lib.nixosSystem {
	    specialArgs = { inherit inputs system;};
	    system = "x86_64-linux";
	    modules = 
	    [
	    	./configuration.nix
	    ];	
	};

    };


    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
