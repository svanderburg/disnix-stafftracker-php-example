{pkgs, ...}:

{
  services = {
    openssh = {
      enable = true;
    };

    disnix = {
      enable = true;
    };

    mysql = {
      enable = true;
      rootPassword = ./mysqlpw;
      initialScript = ./mysqlscript;
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
