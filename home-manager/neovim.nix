{ config, ... }:

{
  programs.nixvim = {
    enable = true;

    plugins = {
      lsp = {
        enable = true;

        servers = {
          nixd = {
            enable = true;
          };
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
        ];
      };

      treesitter = {
        enable = true;

        settings = {
          auto_install = true;
          highlight.enable = true;
          indent.enable = true;
        };

        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          nix
        ];
      };
    };

    opts = {
      number = true;
      relativenumber = true;

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;

      scrolloff = 8;
    };

    colorschemes.onedark = {
      enable = true;
      settings.style = "warmer";
    };
  };
}
