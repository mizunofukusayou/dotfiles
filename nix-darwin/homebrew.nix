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
      "appcleaner"
      "arc"
      "brave-browser"
      "claude"
      "discord"
      "logi-options+"
      "obsidian"
      "slack"
      "steam"
      "zen"
    ];
  };
}
