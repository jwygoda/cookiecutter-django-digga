final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`
  {{cookiecutter.project_name}} = prev.callPackage ./{{cookiecutter.project_name}} { };
}
