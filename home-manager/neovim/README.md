# lazyvim-nix

[lazyvim-nix/data/dependencies.json](https://github.com/pfassina/lazyvim-nix/blob/main/data/dependencies.json) から対象のコミットものをダウンロードしてきて、lazyvim-nix が設定している依存関係を確認する。

```bash
jq '.extras."lang.clangd"' dependencies.json
```

[LazyVim/lua/lazyvim/plugins/extras](https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/plugins/extras) で実際に必要としているツールを確認する。

## 例(lang.clangd)

```bash
jq '.extras."lang.clangd"' dependencies.json
# [
#   {
#     "name": "clangd",
#     "nixpkg": "clang-tools"
#   },
#   {
#     "name": "codelldb",
#     "nixpkg": "vscode-extensions.vadimcn.vscode-lldb"
#   }
# ]
```

```lua:LazyVim/lua/lazyvim/plugins/extras/lang/clangd.lua
return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      root = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac", -- AutoTools
        "meson.build",
        "build.ninja",
      },
    })
  end,

  -- Add C/C++ to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "cpp" } },  <- treesitterでcppのパーサーを必要としている
  },

  {
    "p00f/clangd_extensions.nvim",  <- このプラグインを読み込んでるけど依存関係はわからない
    ft = { "c", "cpp", "objc", "objcpp" },
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },

  -- Correctly setup lspconfig for clangd 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_markers = {
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac", -- AutoTools
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja",
            ".git",
          },
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",  <- clangd を必要としている
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",  <- このプラグインを読み込んでるけど依存関係はわからない
    optional = true,
    opts = function(_, opts)
      opts.sorting = opts.sorting or {}
      opts.sorting.comparators = opts.sorting.comparators or {}
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
    end,
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      -- Ensure C/C++ debugger is installed
      "mason-org/mason.nvim",
      optional = true,
      opts = { ensure_installed = { "codelldb" } },  <- codelldb を必要としている
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["codelldb"] then
        require("dap").adapters["codelldb"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "codelldb",
            args = {
              "--port",
              "${port}",
            },
          },
        }
      end
      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
          },
          {
            type = "codelldb",
            request = "attach",
            name = "Attach to process",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
```

### 分析

| 見つけたもの | 対応 |
| --- | --- |
| treesitterでcppのパーサーを必要としている | [treesitter は lazyvim-nix が解消してくれているはずだから大丈夫](https://github.com/pfassina/lazyvim-nix/wiki/Configuration-Reference#treesitterparsers) |
| このプラグインを読み込んでるけど依存関係はわからない | 困ったら確認する |
| clangd を必要としている | lazyvim-nix が解決済み |
| codelldb を必要としている | lazyvim-nix が解決済み |
