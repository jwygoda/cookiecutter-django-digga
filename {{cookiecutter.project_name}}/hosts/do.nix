{ modulesPath, suites, ... }:
{
  imports = [ ./base.nix "${toString modulesPath}/virtualisation/digital-ocean-image.nix" ] ++ suites.prod;
}
