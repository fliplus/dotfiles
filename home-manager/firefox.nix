{ pkgs, user, ... }:
let
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "master";
    hash = "sha256-CxPZxo9G44lRocNngjfwTBHSqL5dEJ5MNO5Iauoxp2Y=";
  };
in
{
  programs.firefox = {
    enable = true;

    profiles.${user} = {
      extraConfig = builtins.concatStringsSep "\n" [ (builtins.readFile "${betterfox}/user.js") ];
    };
  };

  custom.persist = {
    home.directories = [ ".mozilla" ];
  };
}
