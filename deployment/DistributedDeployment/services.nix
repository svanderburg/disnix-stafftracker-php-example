{distribution, system}:

let pkgs = import ../top-level/all-packages.nix { inherit system; };
in
rec {
### Databases
  
  rooms = {
    name = "rooms";
    pkg = pkgs.rooms;
    dependsOn = {};
    type = "mysql-database";
  };
  
  staff = {
    name = "staff";
    pkg = pkgs.staff;
    dependsOn = {};
    type = "mysql-database";
  };
  
  zipcodes = {
    name = "zipcodes";
    pkg = pkgs.zipcodes;
    dependsOn = {};
    type = "mysql-database";
  };

### Web applications

  stafftracker = {
    name = "stafftracker";
    pkg = pkgs.stafftracker;
    dependsOn = {
      inherit rooms staff zipcodes;
    };
    type = "apache-webapplication";
  };
}
