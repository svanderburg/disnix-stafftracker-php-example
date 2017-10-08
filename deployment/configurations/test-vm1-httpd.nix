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
      enablePHP = true;
      extraConfig = ''
        DirectoryIndex index.php
      '';
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
