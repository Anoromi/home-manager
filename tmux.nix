{ pkgs, ... }:
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
          plugin = tmuxPlugins.catppuccin;
          extraConfig = '' 
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_date_time "%H:%M"
            set -g @catppuccin_flavour 'latte'
            '';
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

      bind C-o display-popup -E \"tms\"

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
