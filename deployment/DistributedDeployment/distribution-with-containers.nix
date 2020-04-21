{infrastructure}:

let
  applicationServicesDistribution = import ./distribution.nix {
    inherit infrastructure;
  };
in
{
  mysql = [ infrastructure.test2 ];
  simpleWebappApache = [ infrastructure.test1 ];
} // applicationServicesDistribution
