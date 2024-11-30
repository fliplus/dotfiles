{ lib, pkgs, user, ... }:

{
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./hyprland.nix
    ./neovim.nix
    ./impermanence.nix
    ./shell.nix
    ./theme.nix
  ];

  options.custom = with lib; {
    isLaptop = mkEnableOption "isLaptop";
  };

  config = {
    home = {
      stateVersion = "24.05"; # Don't change this value.

      username = user;
      homeDirectory = "/home/${user}";

      sessionVariables = {
        EDITOR = "nvim";
      };

      packages = with pkgs; [
        _1password-gui
        prismlauncher
        spotify
        vesktop
        wofi

        nerd-fonts.jetbrains-mono
      ];
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    xdg.enable = true;

    fonts.fontconfig.enable = true;

    custom.persist.home = {
      directories = [
        "dev"
        "Downloads"
        "Games"
        "Pictures"

        ".config/1Password"
        ".config/spotify"
        ".config/vesktop"
        ".local/share/PrismLauncher"
      ];
    };
  };
}
