{ modulesPath, suites, ... }:
{
  imports = [ ./base.nix ] ++ suites.dev;
}
