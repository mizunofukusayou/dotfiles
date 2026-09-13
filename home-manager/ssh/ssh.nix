_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      # GitHub
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_github";
      };
    };
  };
}
