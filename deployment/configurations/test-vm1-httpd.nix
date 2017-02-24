{pkgs, ...}:

{
  services = {
    disnix = {
      enable = true;
    };
    
    openssh = {
      enable = true;
    };
    
    httpd = {
      enable = true;
      documentRoot = "/var/www";
      adminAddr = "admin@localhost";
      extraModules = [
        { name = "php7"; path = "${pkgs.php}/modules/libphp7.so"; }
      ];
    };
  };
  
  networking.firewall.allowedTCPPorts = [ 80 ];
  
  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
    ];
  };
}
