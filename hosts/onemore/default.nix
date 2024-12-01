{
  imports = [
    ./disko.nix
    ./hardware.nix
    ./nvidia.nix
  ];

  config = {
    hm.custom = {
      monitors = [
        {
          name = "HDMI-A-1";
          resolution = "1920x1080";
          refreshRate = 240;
          position = "0x0";
          workspaces = [ 1 2 3 4 5 6 7 8 ];
        }
        {
          name = "DP-1";
          resolution = "1920x1080";
          refreshRate = 144;
          position = "1920x0";
          workspaces = [ 9 10 ];
        }
      ];
    };

    environment.etc."libinput/local-overrides.quirks".text = ''
      [Disable Debounce]
      MatchUdevType=mouse
      ModelBouncingKeys=1
    '';
  };
}
