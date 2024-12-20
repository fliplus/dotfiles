{ config, ... }:

{
  programs.ripgrep.enable = true;

  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = " ";
    };

    plugins = {
      lsp = {
        enable = true;

        servers = {
          nixd.enable = true;
        };
      };

      luasnip.enable = true;

      friendly-snippets.enable = true;

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";

            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-n>" = "cmp.mapping.select_next_item()";
          };
        };
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

      telescope = {
        enable = true;

        keymaps = {
          "<leader>ff" = { action = "find_files"; };
          "<leader>fg" = { action = "live_grep"; };
          "<leader>fb" = { action = "buffers"; };
          "<leader>fh" = { action = "help_tags"; };
        };
      };


      nvim-tree.enable = true;

      lualine.enable = true;

      nvim-autopairs.enable = true;

      which-key.enable = true;
    };

    opts = {
      guicursor = "";

      number = true;
      relativenumber = true;

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;

      wrap = false;

      scrolloff = 8;
    };

    files = {
      "after/ftplugin/nix.lua" = {
        localOpts = {
          tabstop = 2;
          softtabstop = 2;
          shiftwidth = 2;
        };
      };
    };

    colorschemes.tokyonight = {
      enable = true;
      settings.style = "night";
    };

    extraConfigLua = ''vim.api.nvim_set_hl(0, "Normal", { bg = "none" })'';
  };
}
