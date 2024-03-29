{ nixpkgs ? <nixpkgs>
, disnix_stafftracker_php_example ? { outPath = ./.; rev = 1234; }
, nix-processmgmt ? { outPath = ../nix-processmgmt; rev = 1234; }
, nix-processmgmt-services ? { outPath = ../nix-processmgmt-services; rev = 1234; }
, officialRelease ? false
, systems ? [ "i686-linux" "x86_64-linux" ]
}:

let
  pkgs = import nixpkgs {};

  disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
    inherit nixpkgs;
  };

  version = builtins.readFile ./version;

  jobs = rec {
    tarball = disnixos.sourceTarball {
      name = "disnix-stafftracker-php-example-tarball";
      src = disnix_stafftracker_php_example;
      inherit officialRelease version;
    };

    build = {
      services = pkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };

          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs system;
        };
        in
        disnixos.buildManifest {
          name = "disnix-stafftracker-php-example";
          inherit tarball version;
          servicesFile = "deployment/DistributedDeployment/services.nix";
          networkFile = "deployment/DistributedDeployment/network.nix";
          distributionFile = "deployment/DistributedDeployment/distribution.nix";
        }
      );

      services-with-containers = pkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };

          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs system;
        };
        in
        disnixos.buildManifest {
          name = "disnix-stafftracker-php-example";
          inherit tarball version;
          servicesFile = "deployment/DistributedDeployment/services-with-containers.nix";
          networkFile = "deployment/DistributedDeployment/network-bare.nix";
          distributionFile = "deployment/DistributedDeployment/distribution-with-containers.nix";
          extraParams = {
            inherit nix-processmgmt nix-processmgmt-services;
          };
        }
      );
    };

    tests =
      let
        testApp = {networkFile, manifest}:

        disnixos.disnixTest {
          name = "disnix-stafftracker-php-example-tests";
          inherit tarball manifest networkFile;
          dysnomiaStateDir = ./tests/state;
          postActivateTimeout = 3; # hack to make restore work
          testScript =
            ''
              # Wait for a while and capture the output of the entry page
              result = test3.succeed("sleep 30; curl --fail http://test1/stafftracker/index.php")

              # The entry page should contain my name :-)

              if "Sander" in result:
                  print("Entry page contains Sander!")
              else:
                  raise Exception("Entry page should contain Sander!")

              # Start Firefox and take a screenshot

              test3.succeed("xterm -e 'firefox http://test1/stafftracker/index.php' >&2 &")
              test3.wait_for_window("Firefox")
              test3.succeed("sleep 30")
              test3.screenshot("screen")
          '';
        };
      in
      {
        services = testApp {
          manifest = builtins.getAttr (builtins.currentSystem) build.services;
          networkFile = "deployment/DistributedDeployment/network.nix";
        };

        services-with-containers = testApp {
          manifest = builtins.getAttr (builtins.currentSystem) build.services-with-containers;
          networkFile = "deployment/DistributedDeployment/network-bare.nix";
        };
      };
  };
in
jobs
