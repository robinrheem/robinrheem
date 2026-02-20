{ config, pkgs, ... }:

{
  imports = [
    ../../homemodules/common.nix
  ];

  home.username = "robin";
  home.homeDirectory = "/home/robin";
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  home.file.".local/opt/.keep".text = "";
  home.file.".local/bin/cursor" = {
    text = ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail
  
        APPIMAGE="$HOME/.local/opt/cursor.AppImage"
  
        if [ ! -x "$APPIMAGE" ]; then
          echo "Cursor AppImage not found at $APPIMAGE"
          echo "Download it from https://cursor.sh and save it there, then make it executable:"
          echo "  mkdir -p \"$HOME/.local/opt\""
          echo "  mv ~/Downloads/Cursor-*.AppImage \"$APPIMAGE\""
          echo "  chmod +x \"$APPIMAGE\""
	  echo "  appimage-run ./cursor.AppImage --appimage-extract # for icon"
          exit 1
        fi
  
        exec appimage-run "$APPIMAGE" "$@"
      '';
      executable = true;
  };
  xdg.enable = true;
  xdg.desktopEntries.cursor = {
    name = "Cursor";
    genericName = "Code Editor";
    comment = "AI-powered code editor";
    exec = "cursor %F";
    terminal = false;
    categories = [ "Development" "IDE" ];
    icon = "${config.home.homeDirectory}/.local/share/icons/cursor.png";
  };
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    appimage-run
    ripgrep
    fd
    bat
    eza
    gh
    rustup
    gcc
    gnumake
    pkg-config
    openssl
    perf
    uv
    nerd-fonts.jetbrains-mono
    llm
    claude-code
    libffi
    zlib
    sqlite
    libxml2
    zathura
    jetbrains.idea
    R
    signal-desktop
  ];
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour "mocha"
        '';
      }
    ];
    extraConfig = ''
      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      # Split panes
      bind | split-window -h
      bind - split-window -v
      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      # Resize panes
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      # Better copy mode
      set -g mode-keys vi
      # Fast switching
      bind Tab last-window
      # Status bar
      set -g status-position bottom
      set -g status-interval 5
      # True color
      set -as terminal-overrides ",*:Tc"
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi V send -X select-line
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      # Notifications
      set -g monitor-activity on
      set -g visual-activity on
      set -g bell-action any
      set -g visual-bell on
    '';
  };
  programs.ghostty = {
    enable = true;
    settings = {
      cursor-style = "block";
      cursor-style-blink = false;
      term = "xterm-256color";
      shell-integration-features = "no-cursor";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 13;
    };
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
    };
    matchBlocks."pondy" = {
      hostname = "ponderosa.biol.berkeley.edu";
      user = "roundRobin";
      identityFile = "~/.ssh/id_ed25519_berkeley";
    };
    matchBlocks."tildy" = {
      hostname = "tilden.biol.berkeley.edu";
      user = "roundRobin";
      identityFile = "~/.ssh/id_ed25519_berkeley";
    };
    matchBlocks."cb" = {
      hostname = "34.11.163.223";
      user = "roundrobin";
      identityFile = "~/.ssh/id_ed25519_berkeley";
    };
    matchBlocks."github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "~/.ssh/id_ed25519_github";
    };
    matchBlocks."ts" = {
      hostname = "song";
      user = "deploy";
    };
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Robin Rheem";
        email = "robinrheem@gmail.com";
      };
      core.editor = "nvim";
    };
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
	"fzf"
	"sudo"
      ];
    };
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#carnage";
      ls = "eza";
      cat = "bat";
    };
  };
  home.stateVersion = "26.05";
}
