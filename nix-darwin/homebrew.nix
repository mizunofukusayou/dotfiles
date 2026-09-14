{ userName, ... }:
{
  nix-homebrew = {
    enable = true;
    user = userName;
  };

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      autoUpdate = false;
      cleanup = "zap";
    };
    global.autoUpdate = false;

    casks = [
      "logi-options+"
      "brave-browser"
      "arc"
      "appcleaner"
      "claude"
      "slack"
      "obsidian"
      "steam"
      "discord"
    ];
  };
}
