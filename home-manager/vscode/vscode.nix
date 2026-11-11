{ pkgs, config, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false; # 拡張機能のインストール先をNixストア内にする(GUIから拡張機能をインストール不可に)

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # ==========================================
        # 基本設定・UI
        # ==========================================
        ms-ceintl.vscode-language-pack-ja # VSCodeの日本語化
        oderwat.indent-rainbow # インデントに色をつける

        # ==========================================
        # ユーティリティ・プレビュー
        # ==========================================
        esbenp.prettier-vscode # コードの自動整形
        # google.gemini-cli-vscode-ide-companion # gemini-cliにカレントディレクトリを渡す
        shd101wyy.markdown-preview-enhanced # Markdownのプレビューを強化、pdf出力を可能に
        tomoki1207.pdf # PDFのプレビューを可能にする
        hediet.vscode-drawio # Draw.io

        # ==========================================
        # 言語サポート: C/C++
        # ==========================================
        # c/c++
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-vscode.cpptools-extension-pack

        vadimcn.vscode-lldb # MacOSでcppdbgを使用するとlldb-miniがメモリリークを起こすため、lldbを使用する

        # ==========================================
        # 言語サポート: Python & Jupyter
        # ==========================================
        # python
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-pylance
        ms-python.vscode-python-envs

        ms-toolsai.jupyter # ipynbをVSCodeで動かすための拡張機能
        ms-toolsai.jupyter-renderers # ipynbファイルで、セルの下にグラフを表示するように
        google.colab # Google Colabの環境で動かせるように
        charliermarsh.ruff # Formatter & Linter

        # ==========================================
        # 言語サポート: Go
        # ==========================================
        # Go言語
        golang.go

        # ==========================================
        # 言語サポート: Nix
        # ==========================================
        # Nix言語
        jnoortheen.nix-ide

        # ==========================================
        # 言語サポート: YAML
        # ==========================================
        # YAML
        redhat.vscode-yaml

        # ==========================================
        # 言語サポート: MATLAB
        # ==========================================
        (pkgs.vscode-utils.extensionFromVscodeMarketplace {
          name = "language-matlab";
          publisher = "mathworks";
          version = "1.3.12";
          sha256 = "sha256-1KKlkTlesZllNyEz4fdQiQjSTZqjsvf7OEDhgFlgXC8";
        })

        # formatter
        (pkgs.vscode-utils.extensionFromVscodeMarketplace {
          name = "matlab-formatter";
          publisher = "affenwiesel";
          version = "2.11.0";
          sha256 = "sha256-a62ybp0hctBOQo/f8iXFpCcv5o63tN4l4d5wvhZ+hEU";
        })

        # ==========================================
        # 言語サポート: Typst
        # ==========================================
        myriad-dreamin.tinymist
      ];

      userSettings = {
        "files.autoSave" = "afterDelay"; # 一定時間（デフォルト1秒）後にファイルを自動保存する
        "files.defaultLanguage" = "markdown"; # 新規ファイルのデフォルト言語をMarkdownに設定
        "files.insertFinalNewline" = true; # ファイルの最後に自動で改行を入れる
        "files.trimFinalNewlines" = true; # ファイルの最後の複数の改行を1つにする

        "explorer.confirmDelete" = false; # ファイル削除時の確認ダイアログを非表示にする
        "explorer.confirmDragAndDrop" = false; # ファイルのドラッグ＆ドロップ移動時の確認を非表示にする

        "workbench.startupEditor" = "none"; # 起動時に`ようこそ`を表示しないようにする
        "workbench.editor.wrapTabs" = true; # タブを多段表示
        "workbench.sideBar.location" = "right"; # サイドバーを右に配置
        "workbench.statusBar.visible" = false; # ステータスバーを非表示にする
        "workbench.activityBar.location" = "top"; # サイドバーのアイコンを上に(サイドバー非表示に共に非表示に)
        "editor.minimap.enabled" = false; # ミニマップを非表示にする
        "window.customTitleBarVisibility" = "windowed"; # 全画面表示でタイトルバーを非表示にする

        "terminal.integrated.enableMultiLinePasteWarning" = "never"; # ターミナルに複数行を貼り付ける際の警告を無効にする
        "terminal.integrated.enableImages" = true; # ターミナルで画像を表示を可能に
        "terminal.integrated.macOptionIsMeta" = true; # MacOSでOptionキーをMetaキーとして使用する

        # GitHub Copilot: 有効化/無効化
        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = false;
          "scminput" = false;
          "markdown" = true;
        };

        "git.confirmSync" = false; # 同期（push/pull）時の確認をスキップ
        "git.autofetch" = true; # 定期的にリモートの変更を自動でチェックする
        "git.enableSmartCommit" = true; # ステージング済みのファイルがない場合、全変更をコミットする

        "diffEditor.ignoreTrimWhitespace" = true; # 差分表示（Diff）で、行末などの空白の違いを無視する

        # Markdown Preview Enhanced: プレビューのテーマ設定
        "markdown-preview-enhanced.previewTheme" = "github-light.css"; # プレビューのテーマをGitHub風にする
        "markdown-preview-enhanced.printBackground" = true; # PDF出力時に背景を印刷する(コードブロックの背景や水平線を表示)
        "markdown-preview-enhanced.scrollSync" = false; # プレビューとエディタのスクロールを同期しない
        # "markdown-preview-enhanced.mathRenderingOption" = "MathJax"; # 数式のレンダリングにMathJaxを使用する

        "go.toolsManagement.autoUpdate" = true; # Go: エラーチェック用のツール群の自動アップデートを有効化

        "github.copilot.nextEditSuggestions.enabled" = true; # GitHub Copilot: 次の編集候補（Next Edit Suggestions）を有効化

        "editor.fontSize" = 18; # エディタのフォントサイズ
        "editor.tabSize" = 4; # エディタのタブ幅を4スペースに設定
        "editor.codeActionsOnSave"."source.organizeImports" = "always"; # 保存時にインポートを自動で整理する設定
        "editor.insertSpaces" = true; # Tabキーでタブ文字の代わりにスペースを入力
        "editor.formatOnSave" = true; # 保存時に自動でコードを整える設定
        "editor.defaultFormatter" = "esbenp.prettier-vscode"; # Prettierをフォーマッターに使うよう指定

        "prettier.tabWidth" = 4; # インデントをスペース4つに

        # コードブロック内のインデントに色をつけないようにする
        "indentRainbow.ignoreErrorLanguages" = [
          "typst"
        ];

        "[c][cpp]"."editor.defaultFormatter" = "ms-vscode.cpptools"; # C/C++ファイルのデフォルトフォーマッタを設定
        "C_Cpp.clang_format_style" =
          "{"
          + "BasedOnStyle: Google," # ベースとしてGoogleのコーディングスタイルを使用する
          + "BreakBeforeBraces: Attach," # 波括弧 '{' を改行せず、関数やif文などと同じ行の末尾に配置する
          + "IndentWidth: 4," # インデントの幅を4つにする
          + "AllowShortIfStatementsOnASingleLine: Always," # 短いif文を1行にまとめる
          + "AllowShortLoopsOnASingleLine: true," # 短いループ文を1行にまとめる
          + "ColumnLimit: 0," # 行の長さ制限を無効にする
          + "}";
        "debug.onTaskErrors" = "showErrors"; # コンパイル時にポップアップが表示されないようにする
        "files.exclude" = {
          "**/*.out" = true; # コンパイル時に生成される.outファイルを非表示にする
          "**/*.dSYM" = true; # デバッグ時に生成される.dSYMディレクトリを非表示にする
        };
        "C_Cpp.default.includePath" = [ ".include" ];

        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide"; # Nixファイルのデフォルトフォーマッタを設定
          "editor.tabSize" = 2; # インデントを2つに
        };

        # jnoortheen.nix-ideの設定
        "nix.formatterPath" = "nixfmt"; # フォーマッタ
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd"; # エラーチェック

        "[yaml]" = {
          "editor.tabSize" = 2; # YAMLファイルのインデントをスペース2つに
          "prettier.tabWidth" = 2; # YAMLファイルのインデントをスペース2つに
        };

        # redhat.vscode-yamlの設定
        "yaml.format.enable" = false; # redhat.vscode-yamlのフォーマットを無効化
        "redhat.telemetry.enabled" = false; # redhat.vscode-yamlの情報提供の無効化

        "telemetry.telemetryLevel" = "off"; # 情報提供の無効化
        "colab.logging.level" = "off"; # Google Colabの情報提供の無効化

        "update.mode" = "none"; # VSCodeからのシステムの変更を無効化

        "MATLAB.showFeatureNotAvailableError" = false; # matlabがインストールされていない時の警告を非表示に
        "[matlab]" = {
          "editor.defaultFormatter" = "AffenWiesel.matlab-formatter"; # `affenwiesel.matlab-formatter`をフォーマッターに
        };
        "MATLAB.installPath" = "/Applications/MATLAB_R2026a.app"; # MATLABのインストールパスを指定
        "terminal.integrated.commandsToSkipShell" = [
          "matlab.interrupt"
        ];
        "MATLAB.telemetry" = false; # MATLABの情報提供を無効化

        "[python]" = {
          "editor.defaultFormatter" = "charliermarsh.ruff"; # `charliermarsh.ruff`をフォーマッターに
          "editor.codeActionsOnSave" = {
            "source.fixAll.ruff" = "explicit"; # Lintエラーの自動修正
            "source.organizeImports.ruff" = "explicit"; # インポートの自動整理
          };
        };

        # hediet.vscode-drawioの設定
        "hediet.vscode-drawio.resizeImages" = null; # Draw.ioで画像をリサイズする際のデフォルトの幅と高さを指定する

        # ==========================================
        # Typst
        # ==========================================
        "[typst]" = {
          "editor.defaultFormatter" = "myriad-dreamin.tinymist"; # `myriad-dreamin.tinymist`をフォーマッターに
        };
        "tinymist.lint.when" = "onType"; # Linterの実行タイミング
        "tinymist.preview.invertColors" = "always"; # プレビューの背景色を反転させる
        "tinymist.typstExtraArgs" = [
          "--package-path"
          "${config.xdg.dataHome}/typst/packages"

          "--package-cache-path"
          "${config.xdg.cacheHome}/typst/packages"
        ];
      };
    };
  };
}
