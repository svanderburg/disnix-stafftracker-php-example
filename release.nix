{ nixpkgs ? /etc/nixos/nixpkgs
, nixos ? /etc/nixos/nixos
, system ? builtins.currentSystem
}:

let
  pkgs = import nixpkgs { inherit system; };
  
  disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
    inherit nixpkgs nixos system;
  };

  jobs = rec {
    tarball =
      { php_mysql ? {outPath = ./.; rev = 1234;}
      , officialRelease ? false}:
    
      disnixos.sourceTarball {
        name = "php-mysql";
	version = builtins.readFile ./version;
	src = php_mysql;
        inherit officialRelease;
      };
      
    build =
      { tarball ? jobs.tarball {} }:
      
      disnixos.buildManifest {
        name = "php-mysql";
	version = builtins.readFile ./version;
	inherit tarball;
	servicesFile = "deployment/DistributedDeployment/services.nix";
	networkFile = "deployment/DistributedDeployment/network.nix";
	distributionFile = "deployment/DistributedDeployment/distribution.nix";
      };
            
    tests = 

      disnixos.disnixTest {
        name = "php-mysql";        
        tarball = tarball {};
        manifest = build {};
	networkFile = "deployment/DistributedDeployment/network.nix";
	testScript =
	  ''
	    $test3->mustSucceed("sleep 10");	      
	    $test3->mustSucceed("firefox http://test1/stafftracker/index.php &");
	    $test3->mustSucceed("sleep 10");
	      
	    $test3->screenshot("screen");
	  '';
      };              
  };
in
jobs
