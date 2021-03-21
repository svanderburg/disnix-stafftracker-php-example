{ pkgs, system, distribution, invDistribution
, stateDir ? "/var"
, runtimeDir ? "${stateDir}/run"
, logDir ? "${stateDir}/log"
, cacheDir ? "${stateDir}/cache"
, spoolDir ? "${spoolDir}/spool"
, libDir ? "${libDir}/lib"
, tmpDir ? (if stateDir == "/var" then "/tmp" else "${stateDir}/tmp")
, forceDisableUserChange ? false
, processManager ? "systemd"
, nix-processmgmt ? ../../../nix-processmgmt
, nix-processmgmt-services ? ../../../nix-processmgmt-services
}:

let
  constructors = import "${nix-processmgmt-services}/service-containers-agnostic/constructors.nix" {
    inherit nix-processmgmt pkgs stateDir runtimeDir logDir cacheDir spoolDir libDir tmpDir forceDisableUserChange processManager;
  };

  applicationServices = import ./services.nix {
    inherit pkgs system distribution invDistribution;
  };

  processType = import "${nix-processmgmt}/nixproc/derive-dysnomia-process-type.nix" {
    inherit processManager;
  };
in
rec {
  apache = constructors.simpleWebappApache {
    port = 80;
    serverAdmin = "root@localhost";
    enablePHP = true;
    documentRoot = "${stateDir}/www";
    type = processType;
  };

  mysql = constructors.mysql {
    port = 3306;
    type = processType;
  };
} // applicationServices
