/*
 * This Nix expression captures all the machines in the network and its properties
 */
{
  test1 = {
    hostname = "10.0.2.2";
    sshTarget = "localhost:2222";
    system = "i686-linux";
  };
  
  test2 = {
    hostname = "10.0.2.3";
    mysqlPort = 3307;
    mysqlUsername = "root";
    mysqlPassword = builtins.readFile ../configurations/mysqlpw;
    sshTarget = "localhost:2223";
    system = "i686-linux";
  }; 
}
