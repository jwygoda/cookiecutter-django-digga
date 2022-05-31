{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.services.{{cookiecutter.project_name}};
in
{
  options.services.{{cookiecutter.project_name}} = {
    enable = mkEnableOption "{{cookiecutter.project_name}}";

    environment = mkOption {
      description = "Environment variables to inject.";
      default = { };
      type = types.attrs;
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/agenix/{{cookiecutter.project_name}}";
      description = ''
        Environment file to inject e.g. secrets into the configuration.
      '';
    };

    package = mkOption {
      description = "Package to use.";
      default = pkgs.{{cookiecutter.project_name}};
      defaultText = "pkgs.{{cookiecutter.project_name}}";
      type = types.package;
    };

    dataDir = mkOption {
      description = "Data directory.";
      default = "/var/lib/{{cookiecutter.project_name}}";
      type = types.path;
    };

    bind = mkOption {
      description = "The socket to bind.";
      default = "127.0.0.1:8000";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.services.{{cookiecutter.project_name}}-server = {
      description = "{{cookiecutter.project_name}} Server Service Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      script = ''
        exec ${cfg.package}/bin/{{cookiecutter.project_name}}-server {{cookiecutter.project_name}}.wsgi --bind ${cfg.bind} --capture-output
      '';
      environment = {
        BASE_DIR = cfg.dataDir;
      } // mapAttrs' (n: v: nameValuePair n (toString v)) cfg.environment;
      serviceConfig = {
        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
        WorkingDirectory = cfg.dataDir;
        User = "{{cookiecutter.project_name}}";
        RuntimeDirectory = "{{cookiecutter.project_name}}";
        RuntimeDirectoryMode = "0755";
      };
    };

    systemd.services.{{cookiecutter.project_name}}-server-restart = {
      after = [ "networking.target" ];
      script = ''
        exec systemctl restart {{cookiecutter.project_name}}-server.service
      '';
    };

    systemd.paths.{{cookiecutter.project_name}}-server-restart = {
      wantedBy = [ "multi-user.target" ];
      pathConfig = {
        PathModified = mkIf (cfg.environmentFile != null) cfg.environmentFile;
      };
    };

    users.users.{{cookiecutter.project_name}} = {
      description = "{{cookiecutter.project_name}} user";
      home = cfg.dataDir;
      createHome = true;
      group = "{{cookiecutter.project_name}}";
      isSystemUser = true;
    };
    users.groups.{{cookiecutter.project_name}} = { };
  };
}
