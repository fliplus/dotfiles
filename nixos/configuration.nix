{ config, lib, pkgs, host, user, ... }:

{
  imports = [
    ./gaming.nix
    ./impermanence.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
    supportedFilesystems = [ "ntfs" ];
  };

  networking.hostName = host;
  networking.networkmanager = {
    enable = true;
    insertNameservers = [ "1.1.1.1" ];
  };

  time.timeZone = "Europe/Lisbon";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];
  };

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  services.displayManager.autoLogin.user = user;
  programs.hyprland.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "password";
    hashedPasswordFile = "/persist/passwords/${user}";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [ vim ];

  custom.persist = {
    root.directories = [
      "/var/lib/nixos"
    ];
    home.directories = [
      "dotfiles"
    ];
  };

  system.stateVersion = "24.05"; # Don't change this value.
}

