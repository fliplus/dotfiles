{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  hm.custom = {
    isLaptop = true;
    monitors = [
      {
        name = "eDP-1";
        resolution = "1366x768";
        refreshRate = 60;
        position = "0x0";
      }
    ];
  };
}
