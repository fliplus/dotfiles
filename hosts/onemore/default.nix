{
  imports = [
    ./disko.nix
    ./hardware.nix
    ./nvidia.nix
  ];

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Disable Debounce]
    MatchUdevType=mouse
    ModelBouncingKeys=1
  '';
}
