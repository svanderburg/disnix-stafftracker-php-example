{system ? builtins.currentSystem}:

let pkgs = import (builtins.getEnv "NIXPKGS_ALL") { inherit system; };
in
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
