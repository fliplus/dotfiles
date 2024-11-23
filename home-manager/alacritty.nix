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
      };

      font = {
        size = 12;

        normal = fontFamily "Regular";
        bold = fontFamily "Bold";
        italic = fontFamily "Italic";
        bold_italic = fontFamily "Bold Italic";
      };
    };
  };
}
