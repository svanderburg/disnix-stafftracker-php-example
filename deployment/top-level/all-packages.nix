{system, pkgs}:

with pkgs;

rec {
### Databases

  rooms = import ../pkgs/databases/rooms {
    inherit stdenv;
  };
  
  staff = import ../pkgs/databases/staff {
    inherit stdenv;
  };
  
  zipcodes = import ../pkgs/databases/zipcodes {
    inherit stdenv;
  };

### Web applications

  stafftracker = import ../pkgs/webapplications/stafftracker {
    inherit stdenv;
  };
}
