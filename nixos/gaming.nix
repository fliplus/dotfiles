{
  programs.steam.enable = true;

  programs.gamemode.enable = true;

  custom.persist = {
    home.directories = [
      ".local/share/Steam"
    ];
  };
}
