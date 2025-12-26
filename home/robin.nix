{ config, pkgs, ... }:

{
  home.username = "robin";
  home.homeDirectory = "/home/robin";
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Robin Rheem";
    userEmail = "robinrheem@gmail.com";
  };
  home.packages = with pkgs; [
    neovim
    code-cursor
  ];
  programs.zsh.enable = true;
  home.stateVersion = "25.11";
}
