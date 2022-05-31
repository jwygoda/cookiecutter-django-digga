{ pkgs ? import <nixpkgs> {}, system ? builtins.currentSystem }:
let
  src = fetchTarball "https://github.com/numtide/devshell/archive/master.tar.gz";
  devshell = import src { inherit system; };

  {{cookiecutter.project_name}} = pkgs.poetry2nix.mkPoetryEnv {
    projectDir = ./.;
    editablePackageSources = {
      {{cookiecutter.project_name}} = ./src;
    };
    python = pkgs.python39;
    overrides = pkgs.poetry2nix.overrides.withDefaults (self: super: {
      # workaround https://github.com/nix-community/poetry2nix/issues/568
      pyparsing = super.pyparsing.overridePythonAttrs (old: {
        buildInputs = old.buildInputs or [ ] ++ [ pkgs.python39.pkgs.flit-core ];
      });
    });
  };
in
{
  devShell = devshell.mkShell {
    imports = [ (devshell.importTOML ./devshell.toml) ];
    devshell.packages = [ {{cookiecutter.project_name}} ];
  };
}
