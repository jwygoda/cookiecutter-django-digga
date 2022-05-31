{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [ 8080 ];

  services.caddy = {
    enable = true;
    config = ''
      localhost:8080 {
        encode gzip
        reverse_proxy ${config.services.{{cookiecutter.project_name}}.bind}
      }
    '';
  };

  services.{{cookiecutter.project_name}} = {
    enable = true;
    environment = {
      DEBUG = "true";
    };
  };
}
