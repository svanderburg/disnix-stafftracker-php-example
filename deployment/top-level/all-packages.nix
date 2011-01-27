{system, pkgs}:

rec {
### Databases

  rooms = import ../pkgs/databases/rooms {
    inherit (pkgs) stdenv;
  };
  
  staff = import ../pkgs/databases/staff {
    inherit (pkgs) stdenv;
  };
  
  zipcodes = import ../pkgs/databases/zipcodes {
    inherit (pkgs) stdenv;
  };

### Web applications

  stafftracker = import ../pkgs/webapplications/stafftracker {
    inherit (pkgs) stdenv;
  };
}
