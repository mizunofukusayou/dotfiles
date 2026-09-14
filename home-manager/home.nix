{ pkgs, ... }:
{
  imports = [
    ./git/git.nix
    ./hotkey/hotkey.nix
    ./neovim/neovim.nix
    ./shell/shell.nix
    ./ssh/ssh.nix
    ./utils/utils.nix
    ./vscode/vscode.nix
  ];

  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core CLI & Utilities
    tree
    keepassxc # ローカルパスワード管理
    tldr
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  programs.home-manager.enable = true;
}
