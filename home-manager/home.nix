{ config, pkgs, user, ... }:

{
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./hyprland.nix
    ./impermanence.nix
    ./shell.nix
    ./theme.nix
  ];

  home = {
    stateVersion = "24.05"; # Don't change this value.

    username = user;
    homeDirectory = "/home/${user}";

    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      _1password-gui
      neovim
      prismlauncher
      spotify
      vesktop
      wofi
    
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.enable = true;

  fonts.fontconfig.enable = true;

  custom.persist.home = {
    directories = [
      "Downloads"
      "Pictures"
      "Games"

      ".config/1Password"
      ".config/vesktop"
      ".local/share/PrismLauncher"
    ];
  };
}
