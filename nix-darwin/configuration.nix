_: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  nix.enable = true;

  imports = [
    ./system.nix
    ./keymap.nix
    ./home_manager.nix
    ./homebrew.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true; # ハードリンクでストアを最適化する

      experimental-features = "fetch-tree nix-command flakes"; # フレークと新しいNixコマンドを有効化する

      bash-prompt-prefix = "(nix:$name)\\040"; # `nix-shell` や `nix develop` に入った際、プロンプトに環境名を表示

      nix-path = [ "nixpkgs=flake:nixpkgs" ]; # 従来の `<nixpkgs>` の参照先を、モダンな Flakes の登録先に統一

      sandbox-fallback = false; # サンドボックスが利用できない場合はビルドを失敗させ、環境の汚染を防ぐ

      sandbox = true; # サンドボックスを有効化することで、ビルド環境の汚染を防ぐ
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
