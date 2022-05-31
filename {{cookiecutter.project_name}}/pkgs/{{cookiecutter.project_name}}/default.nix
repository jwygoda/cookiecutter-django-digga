{ pkgs ? import <nixpkgs> {}, system ? builtins.currentSystem }:

pkgs.poetry2nix.mkPoetryApplication {
  projectDir = ./.;
  python = pkgs.python39;
  overrides = pkgs.poetry2nix.overrides.withDefaults (self: super: {
    # workaround https://github.com/nix-community/poetry2nix/issues/568
    pyparsing = super.pyparsing.overridePythonAttrs (old: {
      buildInputs = old.buildInputs or [ ] ++ [ pkgs.python39.pkgs.flit-core ];
    });
  });
}
