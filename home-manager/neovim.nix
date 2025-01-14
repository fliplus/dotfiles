{
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
          transparent = true;
        };

        statusline.lualine.enable = true;

        autocomplete.nvim-cmp.enable = true;
        snippets.luasnip.enable = true;

        languages = {
          enableLSP = true;
          enableTreesitter = true;

          nix.enable = true;
        };

        telescope.enable = true;
        autopairs.nvim-autopairs.enable = true;

        binds.whichKey.enable = true;

        options = {
          guicursor = "";

          number = true;
          relativenumber = true;

          tabstop = 4;
          softtabstop = 4;
          shiftwidth = 4;
          expandtab = true;

          wrap = false;

          scrolloff = 8;

          signcolumn = "yes";
          colorcolumn = "80";
        };
      };
    };
  };
}
