{ pkgs, ... }:
let
  rose-pine = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "rose-pine";
      version = "whatever";
      src = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "tmux";
        rev = "main";
        sha256 = "sha256-OJMBCZwqrEu2DTlojqQ3pIp2sfjIzT9ORw0ajVgZ8vo=";
      };
    };
in
{
  programs.tmux = {
    enable = true;
    # shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    historyLimit = 100000;
    prefix = "C-Space";
    plugins = with pkgs;
      [
        # {
        #   plugin = tmuxPlugins.tpm;
        #   extraConfig = "
        #     run '~/.tmux/plugins/tpm/tpm'
        #   ";
        # }
        tmuxPlugins.better-mouse-mode
				{
					plugin = rose-pine;
					extraConfig = "
set -g @catppuccin_window_tabs_enabled on
set -g @catppuccin_date_time \"%H:%M\"
set -g @catppuccin_flavour 'latte'
					";
				}
     #    {
     #      plugin = rose-pine;
					# extraConfig = "set -g @rose-pine_flavour 'dawn'";
     #    }
        {
          plugin = tmuxPlugins.catppuccin;
          # extraConfig = '' 
          #   '';
        }
        {
          plugin = tmuxPlugins.sensible;
        }

      ];
    extraConfig = "
      set -g mouse on
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      bind '\"' split-window -v -c \"#{pane_current_path}\"
      bind % split-window -h -c \"#{pane_current_path}\"

      bind  c  new-window      -c \"#{pane_current_path}\"

      bind C-o display-popup -E \"tms\"

      set -g set-titles on
      set -g set-titles-string '#{pane_title}'

			set -ga terminal-overrides \",*256col*:Tc\"
			set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
			set-environment -g COLORTERM \"truecolor\"

			set-window-option -g mode-keys vi
      unbind -T copy-mode-vi h
      unbind -T copy-mode-vi j
      unbind -T copy-mode-vi k
      unbind -T copy-mode-vi l

      bind -T copy-mode-vi h send -X cursor-left
      bind -T copy-mode-vi s send -X cursor-right
      bind -T copy-mode-vi n send -X cursor-up
      bind -T copy-mode-vi t send -X cursor-down

      bind -T copy-mode-vi - send -X end-of-line
      bind -T copy-mode-vi _ send -X start-of-line

      bind -T copy-mode-vi N \\
        send -X cursor-up \\; send -X cursor-up \\; send -X cursor-up \\; send -X cursor-up \\; \\
        send -X cursor-up \\; send -X cursor-up \\; send -X cursor-up \\; send -X cursor-up

      bind -T copy-mode-vi T \\
        send -X cursor-down \\; send -X cursor-down \\; send -X cursor-down \\; send -X cursor-down \\; \\
        send -X cursor-down \\; send -X cursor-down \\; send -X cursor-down \\; send -X cursor-down

      # Setup 'v' to begin selection, just like Vim
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      
      # Setup 'y' to yank (copy), just like Vim
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      
      # Update the default binding of 'Enter' to use copy-selection-and-cancel
      unbind-key -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send-keys -X copy-selection-and-cancel

      bind -T copy-mode-vi l send -X search-again
      bind -T copy-mode-vi L send -X search-reverse   # previous match (optional)
    ";
    # plugins = with pkgs;
    #   [
    #     {
    #       plugin = tmux-super-fingers;
    #       extraConfig = "set -g @super-fingers-key f";
    #     }
    #     tmuxPlugins.better-mouse-mode
    #   ];
    # extraConfig = ''
    # '';
  };
}
