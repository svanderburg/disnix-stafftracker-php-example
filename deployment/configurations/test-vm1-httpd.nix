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
      adminAddr = "admin@localhost";
      enablePHP = true;

      virtualHosts.localhost = {
        documentRoot = "/var/www";
        extraConfig = ''
          DirectoryIndex index.php
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  time.timeZone = "UTC";

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
    ];
  };
}
