{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    neofetch
    nh
    nix-output-monitor
    nvd
    pulsemixer
  ];

  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    history.path = "${config.xdg.dataHome}/zsh/zsh_history";

    shellAliases = {
      vim = "nvim";
    };

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    initExtra = ''
      setopt HIST_FIND_NO_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_SAVE_NO_DUPS
      setopt INC_APPEND_HISTORY
      setopt SHARE_HISTORY

      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey "$terminfo[kcud1]" history-substring-search-down

      zstyle ':completion:*' menu no
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls --color $realpath'
    '';
  };

  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;
      line_break.disabled = true;
      right_format = "$cmd_duration";
    };
  };

  programs.zoxide = {
    enable = true;

    options = [
      "--cmd cd"
    ];
  };

  programs.fzf.enable = true;

  programs.yazi.enable = true;

  programs.git = {
    enable = true;

    userName = "Filipe Abreu";
    userEmail = "134308239+fliplus@users.noreply.github.com";
  };

  programs.ssh = {
    enable = true;

    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
  };

  home.sessionVariables = {
    FLAKE = "${config.home.homeDirectory}/dotfiles";
  };

  custom.persist = {
    home.directories = [
      ".local/share/zoxide"
    ];
    home.files = [
      ".local/share/zsh/zsh_history"
    ];
  };
}
