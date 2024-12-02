let
  fontFamily = style: {
    family = "JetBrainsMono Nerd Font";
    inherit style;
  };
in
{
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 4;
          y = 4;
        };

        opacity = 0.9;
      };

      font = {
        size = 12;

        normal = fontFamily "Regular";
        bold = fontFamily "Bold";
        italic = fontFamily "Italic";
        bold_italic = fontFamily "Bold Italic";
      };

      colors = {
        primary = {
          background = "#1a1b26";
          foreground = "#a9b1d6";
        };
        normal = {
          black   = "#32344a";
          red     = "#f7768e";
          green   = "#9ece6a";
          yellow  = "#e0af68";
          blue    = "#7aa2f7";
          magenta = "#ad8ee6";
          cyan    = "#449dab";
          white   = "#787c99";
        };
        bright = {
          black   = "#444b6a";
          red     = "#ff7a93";
          green   = "#b9f27c";
          yellow  = "#ff9e64";
          blue    = "#7da6ff";
          magenta = "#bb9af7";
          cyan    = "#0db9d7";
          white   = "#acb0d0";
        };
      };
    };
  };
}
