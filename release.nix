{ nixpkgs ? <nixpkgs>
, disnix_stafftracker_php_example ? {outPath = ./.; rev = 1234;}
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
          inherit tarball version;
          servicesFile = "deployment/DistributedDeployment/services.nix";
          networkFile = "deployment/DistributedDeployment/network.nix";
          distributionFile = "deployment/DistributedDeployment/distribution.nix";
        }
      );

    tests = disnixos.disnixTest {
      name = "disnix-stafftracker-php-example-tests";
      inherit tarball;
      manifest = builtins.getAttr (builtins.currentSystem) build;
      networkFile = "deployment/DistributedDeployment/network.nix";
      dysnomiaStateDir = ./tests/state;
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

          test3.succeed("firefox http://test1/stafftracker/index.php &")
          test3.wait_for_window("Firefox")
          test3.succeed("sleep 30")
          test3.screenshot("screen")
        '';
    };
  };
in
jobs
