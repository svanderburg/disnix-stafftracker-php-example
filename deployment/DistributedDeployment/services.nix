{distribution, invDistribution, system, pkgs}:

let customPkgs = import ../top-level/all-packages.nix { inherit system pkgs; };
in
rec {
### Databases
  
  rooms = {
    name = "rooms";
    pkg = customPkgs.rooms;
    dependsOn = {};
    type = "mysql-database";
  };
  
  staff = {
    name = "staff";
    pkg = customPkgs.staff;
    dependsOn = {};
    type = "mysql-database";
    deployState = true;
  };
  
  zipcodes = {
    name = "zipcodes";
    pkg = customPkgs.zipcodes;
    dependsOn = {};
    type = "mysql-database";
  };

### Web applications

  stafftracker = {
    name = "stafftracker";
    pkg = customPkgs.stafftracker;
    dependsOn = {
      inherit rooms staff zipcodes;
    };
    type = "apache-webapplication";
  };
}
