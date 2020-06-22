{ pkgs, system, distribution, invDistribution
, stateDir ? "/var"
, runtimeDir ? "${stateDir}/run"
, logDir ? "${stateDir}/log"
, cacheDir ? "${stateDir}/cache"
, tmpDir ? (if stateDir == "/var" then "/tmp" else "${stateDir}/tmp")
, forceDisableUserChange ? false
, processManager ? "systemd"
}:

let
  constructors = import ../../../nix-processmgmt/examples/service-containers-agnostic/constructors.nix {
    inherit pkgs stateDir runtimeDir logDir cacheDir tmpDir forceDisableUserChange processManager;
  };

  applicationServices = import ./services.nix {
    inherit pkgs system distribution invDistribution;
  };

  processType = import ../../../nix-processmgmt/nixproc/derive-dysnomia-process-type.nix {
    inherit processManager;
  };
in
rec {
  simpleWebappApache = constructors.simpleWebappApache {
    port = 80;
    serverAdmin = "root@localhost";
    enablePHP = true;
    documentRoot = "/var/www";
    type = processType;
  };

  mysql = constructors.mysql {
    port = 3306;
    type = processType;
  };
} // applicationServices
