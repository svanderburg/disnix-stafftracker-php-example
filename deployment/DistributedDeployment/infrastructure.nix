/*
 * This Nix expression captures all the machines in the network and its properties
 */
{
  test1 = {
    properties = {
      hostname = "10.0.2.2";
      sshTarget = "localhost:2222";
    };
    system = "i686-linux";
  };
  
  test2 = {
    properties = {
      hostname = "10.0.2.3";
      sshTarget = "localhost:2223";
      system = "i686-linux";
    };
    
    containers = {
      mysql-database = {
        mysqlPort = 3307;
        mysqlUsername = "root";
        mysqlPassword = builtins.readFile ../configurations/mysqlpw;
      };
    };
  };
}
