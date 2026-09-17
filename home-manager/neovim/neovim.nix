{
  lazyvim,
  lib,
  pkgs,
  ...
}:
{
  imports = [ lazyvim.homeManagerModules.default ];
  programs.lazyvim = {
    enable = true;

    extras = {
      lang =
        lib.genAttrs
          [
            "clangd"
            "markdown"
            "nix"
            "typst"
          ]
          (_: {
            enable = true;
            installDependencies = true;
          });
    };

    extraPackages = with pkgs; [
      # lang.nix
      statix
      nil

      # lua
      lua-language-server
      stylua

      # lang.typst
      typstyle
    ];

    config.options = ''
      vim.opt.exrc = true
    '';
  };

  programs.neovim = {
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
  };
}
