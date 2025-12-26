{ config, pkgs, ... }:

{
  home.username = "robin";
  home.homeDirectory = "/home/robin";
  home.packages = with pkgs; [
    neovim
    code-cursor
    fzf
  ];
  programs.home-manager.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
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
    settings.user = {
      name = "Robin Rheem";
      email = "robinrheem@gmail.com";
      core.editor = "nvim";
    };
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
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
    };
  };
  home.stateVersion = "25.11";
}
