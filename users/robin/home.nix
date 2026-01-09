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
  home.packages = with pkgs; [
    neovim
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
  ];
  programs.home-manager.enable = true;
  programs.ghostty = {
    enable = true;
    settings = {
      cursor-style = "block";
      cursor-style-blink = false;
      term = "xterm-256color";
      shell-integration-features = "no-cursor";
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
  home.stateVersion = "25.11";
}
