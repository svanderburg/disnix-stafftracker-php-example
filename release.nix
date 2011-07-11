{ nixpkgs ? /etc/nixos/nixpkgs
, nixos ? /etc/nixos/nixos
}:

let
  
  jobs = rec {
    tarball =
      { php_mysql ? {outPath = ./.; rev = 1234;}
      , officialRelease ? false}:
    
      let
        pkgs = import nixpkgs {};
  
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs nixos;
        };
      in
      disnixos.sourceTarball {
        name = "php-mysql";
	version = builtins.readFile ./version;
	src = php_mysql;
        inherit officialRelease;
      };
      
    doc =
      { tarball ? jobs.tarball {} }:
      
      with import nixpkgs {};
      
      releaseTools.nixBuild {
        name = "php-mysql-doc";
	version = builtins.readFile ./version;
	src = tarball;
	buildInputs = [ libxml2 libxslt dblatex tetex ];
	
	buildPhase = ''
	  cd doc
	  make docbookrng=${docbook5}/xml/rng/docbook docbookxsl=${docbook5_xsl}/xml/xsl/docbook
	'';
	
	checkPhase = "true";
	
	installPhase = ''
	  make DESTDIR=$out install
	 
	  echo "doc manual $out/share/doc/php-mysql/manual" >> $out/nix-support/hydra-build-products
	'';
      };
      
    build =
      { tarball ? jobs.tarball {}
      , system ? "x86_64-linux"
      }:
      
      let
        pkgs = import nixpkgs { inherit system; };
  
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs nixos system;
        };
      in
      disnixos.buildManifest {
        name = "php-mysql";
	version = builtins.readFile ./version;
	inherit tarball;
	servicesFile = "deployment/DistributedDeployment/services.nix";
	networkFile = "deployment/DistributedDeployment/network.nix";
	distributionFile = "deployment/DistributedDeployment/distribution.nix";
      };
            
    tests = 

      let
        pkgs = import nixpkgs {};
  
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs nixos;
        };
      in
      disnixos.disnixTest {
        name = "php-mysql";        
        tarball = tarball {};
        manifest = build { system = "x86_64-linux"; };
	networkFile = "deployment/DistributedDeployment/network.nix";
	testScript =
	  ''
	    # Wait for a while and capture the output of the entry page
	    my $result = $test3->mustSucceed("sleep 30; curl --fail http://test1/stafftracker/index.php");
	    
	    # The entry page should contain my name :-)
	    
	    if ($result =~ /Sander/) {
	        print "Entry page contains Sander!\n";
	    }
	    else {
	        die "Entry page should contain Sander!\n";
	    }
	    
	    # Start Firefox and take a screenshot
	    
	    $test3->mustSucceed("firefox http://test1/stafftracker/index.php &");
	    $test3->waitForWindow(qr/Aurora/);
	    $test3->mustSucceed("sleep 30");  
	    $test3->screenshot("screen");
	  '';
      };              
  };
in
jobs
