{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  config.hm.custom = {
    isLaptop = true;
  };
}
