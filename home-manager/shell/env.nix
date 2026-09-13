# 環境変数、パスの追加、エイリアスなど、シェルの環境をカスタマイズする
_: {
  xdg.enable = true;

  home = {
    language = {
      base = "ja_JP.UTF-8";
      ctype = "ja_JP.UTF-8";
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      dr = "defaults read";
      yy = "pbcopy";
      diff = "code -d";
      github = "gh repo view -w";
      cornix = "open ~/dev/github.com/mizunofukusayou/keymap/cornix/layout.pdf";
      t = "task";
    };
  };
}
