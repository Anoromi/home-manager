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
        sha256 = "sha256-YnpWvW0iWANB0snVhLKBTnOXlD3LQfbeoSFeae7SJ0c=";
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
