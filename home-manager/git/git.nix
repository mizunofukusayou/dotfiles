_: {
  imports = [
    ./gh.nix
  ];

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "mizunofukusayou";
        email = "145898250+mizunofukusayou@users.noreply.github.com";
      };

      init.defaultBranch = "main"; # デフォルトのブランチ名を main に設定
      pull.rebase = true; # git pull 時に自動で rebase を行う

      merge.conflictStyle = "zdiff3"; # コンフリクト時に「変更前（Base）」のコードも表示して比較しやすくする
      rerere.enabled = true; # 一度解決したコンフリクトの手順を記憶し、同じ衝突を自動で解決する

      rebase.autoStash = true; # 未コミットの変更があっても、自動で stash して rebase を実行する

      log.date = "iso"; # git log の日時フォーマットを直感的な ISO 形式（YYYY-MM-DD）にする
      push.autoSetupRemote = true; # 新しいブランチの初回 push 時に --set-upstream を自動で行う

      alias = {
        aa = "add .";
        an = "add -N .";
        c = "commit";
        cm = "commit -m";
        st = "status -sb";
      };
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      ".direnv/"
    ];
  };

  home.shellAliases = {
    gsw = "git branch | fzf | xargs git switch";
  };
}
