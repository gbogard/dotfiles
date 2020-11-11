{ pkgs, ... }:

with pkgs; {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    plugins = [
      {
        name = "zsh-vim-mode";
        src = pkgs.fetchFromGitHub {
          owner = "softmoth";
          repo = "zsh-vim-mode";
          rev = "abef0c0c03506009b56bb94260f846163c4f287a";
          sha256 = "0cnjazclz1kyi13m078ca2v6l8pg4y8jjrry6mkvszd383dx1wib";
        };
      }
      {
        name = "zsh-aliases-exa";
        src = pkgs.fetchFromGitHub {
          owner = "DarrinTisdale";
          repo = "zsh-aliases-exa";
          rev = "f6b72da193f03911009cb95e3e2e18e48b918833";
          sha256 = "0xzdahcahjv2mag5g7kzidg3bg0g01xwn0j47fwpsa0knpcsx1c7";
        };
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-history-substring-search";
          rev = "0f80b8eb3368b46e5e573c1d91ae69eb095db3fb";
          sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
        };
      }
    ];
    initExtraBeforeCompInit =
      # Initialise nix path on macOs
      ". $HOME/.nix-profile/etc/profile.d/nix.sh;" +
      # Start starship
      "source <(starship init zsh --print-full-init)";
    initExtra =
      # Configure bindings for history search
      "bindkey '^[[A' history-substring-search-up
       bindkey '^[[B' history-substring-search-down;" +
      # Set auto cd
      "setopt auto_cd";
    shellAliases = {
      ps = "procs";
    };
  };
  programs.tmux = {
    enable = true;
    newSession = true;
    keyMode = "vi";
    extraConfig = ''
    unbind C-b
    set -g prefix C-Space
    bind Space send-prefix
    set -g mouse on
    bind | split-window -h -c "#{pane_current_path}"
    bind - split-window -v -c "#{pane_current_path}"
    '';
  };
  home.packages = [
    starship
    exa
    procs
    tokei
  ];
}
