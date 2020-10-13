{distribution, invDistribution, system, pkgs}:

let customPkgs = import ../top-level/all-packages.nix { inherit system pkgs; };
in
rec {
### Databases

  rooms = rec {
    name = "rooms";
    mysqlUsername = "rooms";
    mysqlPassword = "rooms";
    pkg = customPkgs.rooms {
      inherit mysqlUsername mysqlPassword;
    };
    dependsOn = {};
    type = "mysql-database";
  };

  staff = rec {
    name = "staff";
    mysqlUsername = "staff";
    mysqlPassword = "staff";
    pkg = customPkgs.staff {
      inherit mysqlUsername mysqlPassword;
    };
    dependsOn = {};
    deployState = true; # Migrate state as well
    type = "mysql-database";
  };

  zipcodes = rec {
    name = "zipcodes";
    mysqlUsername = "zipcodes";
    mysqlPassword = "zipcodes";
    pkg = customPkgs.zipcodes {
      inherit mysqlUsername mysqlPassword;
    };
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
