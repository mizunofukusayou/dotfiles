_: {
  programs.fzf = {
    enable = true;

    defaultCommand = "fd --type f --hidden --exclude .git"; # 検索コマンドに`fd`を使う

    # 常に適用されるオプション (見た目や挙動の調整)
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--inline-info"
    ];

    # Ctrl+T (ファイル検索ウィジェット) の設定
    fileWidgetCommand = "fd --type f --hidden --exclude .git";
    fileWidgetOptions = [
      "--preview 'bat --color=always {}'"
    ];

    # Alt+C (ディレクトリ移動ウィジェット) の設定
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -200'"
    ];

    # Ctrl+R (コマンド履歴検索ウィジェット) の設定
    historyWidgetOptions = [
      "--layout=reverse"
      "--sort"
      "--exact"
    ];
  };
}
