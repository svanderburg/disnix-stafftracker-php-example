{system, pkgs}:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  
  self = {
  ### Databases

    rooms = callPackage ../pkgs/databases/rooms { };
  
    staff = callPackage ../pkgs/databases/staff { };
  
    zipcodes = callPackage ../pkgs/databases/zipcodes { };

  ### Web applications

    stafftracker = callPackage ../pkgs/webapplications/stafftracker { };
  };
in
self
