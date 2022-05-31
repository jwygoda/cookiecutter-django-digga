{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    config = ''
      {{cookiecutter.domain_name}} {
        encode gzip
        reverse_proxy ${config.services.{{cookiecutter.project_name}}.bind}
      }
    '';
  };

  services.{{cookiecutter.project_name}} = {
    enable = true;
    environment = {
      ALLOWED_HOSTS = "{{cookiecutter.domain_name}}";
      DEBUG = "false";
    };
  };
}
