{pkgs, ...}:

{
  services = {
    disnix = {
      enable = true;
    };
    
    openssh = {
      enable = true;
    };

    mysql = {
      enable = true;
      rootPassword = ./mysqlpw;
      initialScript = ./mysqlscript;
      package = pkgs.mysql;
    };
  };
  
  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
    ];
  };  
}
