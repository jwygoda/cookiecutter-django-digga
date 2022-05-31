{ suites, ... }:
{
  imports = suites.base;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  boot = {
    loader = {
      grub.device = "/dev/vda";
    };
  };


  nix.trustedUsers = [ "root" "@wheel" ];

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    openFirewall = true;
    permitRootLogin = "no";
  };
}
