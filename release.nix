{ nixpkgs ? <nixpkgs>
, disnix_stafftracker_php_example ? {outPath = ./.; rev = 1234;}
, officialRelease ? false
, systems ? [ "i686-linux" "x86_64-linux" ]
}:

let
  pkgs = import nixpkgs {};
  
  jobs = rec {
    tarball =
      let
        pkgs = import nixpkgs {};
  
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs;
        };
      in
      disnixos.sourceTarball {
        name = "disnix-stafftracker-php-example-tarball";
        version = builtins.readFile ./version;
        src = disnix_stafftracker_php_example;
        inherit officialRelease;
      };
      
    doc =
      pkgs.releaseTools.nixBuild {
        name = "disnix-stafftracker-php-example-doc";
        version = builtins.readFile ./version;
        src = tarball;
        buildInputs = [ pkgs.libxml2 pkgs.libxslt pkgs.dblatex pkgs.tetex ];
        
        buildPhase = ''
          cd doc
          make docbookrng=${pkgs.docbook5}/xml/rng/docbook docbookxsl=${pkgs.docbook5_xsl}/xml/xsl/docbook
        '';
        
        checkPhase = "true";
        
        installPhase = ''
          make DESTDIR=$out install
         
          echo "doc manual $out/share/doc/php-mysql/manual" >> $out/nix-support/hydra-build-products
        '';
      };
      
    build =
      pkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };
  
          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs system;
        };
        in
        disnixos.buildManifest {
          name = "disnix-stafftracker-php-example";
          version = builtins.readFile ./version;
          inherit tarball;
          servicesFile = "deployment/DistributedDeployment/services.nix";
          networkFile = "deployment/DistributedDeployment/network.nix";
          distributionFile = "deployment/DistributedDeployment/distribution.nix";
        }
      );
    tests = 
      let
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs;
        };
      in
      disnixos.disnixTest {
        name = "disnix-stafftracker-php-example-tests";
        inherit tarball;
        manifest = builtins.getAttr (builtins.currentSystem) build;
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
            $test3->waitForWindow(qr/Nightly/);
            $test3->mustSucceed("sleep 30");
            $test3->screenshot("screen");
          '';
      };
  };
in
jobs
