# modules/home/apps/nvf.nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.modules.nvf;

  # Helper: plugin attrset with optional config/after/etc
  mkPlugin = p: attrs: { plugin = p; } // attrs;

  # Common dependencies
  plenary = pkgs.vimPlugins.plenary-nvim;
  devicons = pkgs.vimPlugins.nvim-web-devicons;
  nui = pkgs.vimPlugins.nui-nvim;

  coreEnabled = cfg.plugins.enableAll;

  # Compose plugin list with configs
  plugins =
    lib.optionals (coreEnabled || cfg.plugins.treesitter.enable) [
      (mkPlugin pkgs.vimPlugins.nvim-treesitter {
        config = ''
          require('nvim-treesitter.configs').setup {
            highlight = { enable = true },
            incremental_selection = { enable = true },
            indent = { enable = true }
          }
        '';
      })
    ]
    ++ lib.optionals (coreEnabled || cfg.plugins.telescope.enable) [
      plenary
      devicons
      (mkPlugin pkgs.vimPlugins.telescope-nvim {
        config = ''
          local telescope = require('telescope')
          telescope.setup({})
          vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
          vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep)
          vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
          vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)
        '';
      })
    ]
    ++ lib.optionals (coreEnabled || cfg.plugins.lsp.enable) [
      (mkPlugin pkgs.vimPlugins.nvim-lspconfig {
        config = ''
          local lspconfig = require('lspconfig')

          local on_attach = function(_, bufnr)
            local map = function(mode, lhs, rhs)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true })
            end
            map('n', 'gd', vim.lsp.buf.definition)
            map('n', 'K',  vim.lsp.buf.hover)
            map('n', '<leader>rn', vim.lsp.buf.rename)
            map('n', '<leader>ca', vim.lsp.buf.code_action)
          end

          local function try_server(name, opts)
            local ok = pcall(function() lspconfig[name].setup(opts) end)
            if not ok then
              vim.schedule(function()
                vim.notify("LSP '"..name.."' not available", vim.log.levels.WARN)
              end)
            end
          end

          try_server('rust_analyzer', { on_attach = on_attach })
          try_server('lua_ls', {
            on_attach = on_attach,
            settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
          })
          try_server('tsserver', { on_attach = on_attach })
          try_server('nil_ls', { on_attach = on_attach })
          try_server('gopls', { on_attach = on_attach })
          try_server('pyright', { on_attach = on_attach })
        '';
      })
    ]
    ++ lib.optionals (coreEnabled || cfg.plugins.cmp.enable) [
      devicons
      pkgs.vimPlugins.luasnip
      pkgs.vimPlugins.cmp_luasnip
      pkgs.vimPlugins.cmp-nvim-lsp
      pkgs.vimPlugins.cmp-buffer
      pkgs.vimPlugins.cmp-path
      (mkPlugin pkgs.vimPlugins.nvim-cmp {
        config = ''
          local cmp = require('cmp')
          local luasnip = require('luasnip')
          cmp.setup({
            snippet = {
              expand = function(args) luasnip.lsp_expand(args.body) end,
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
              ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                else fallback() end
              end, { 'i', 's' }),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'luasnip' },
              { name = 'path' },
              { name = 'buffer' },
            })
          })
        '';
      })
    ]
    ++ lib.optionals (coreEnabled || cfg.plugins.nullLs.enable) [
      (mkPlugin pkgs.vimPlugins.null-ls-nvim {
        config = ''
          local null_ls = require('null-ls')
          null_ls.setup({
            sources = {
              null_ls.builtins.formatting.black,
              null_ls.builtins.formatting.ruff,
              null_ls.builtins.diagnostics.ruff,
              null_ls.builtins.formatting.prettier,
            }
          })
        '';
      })
    ]
    ++ lib.optionals (coreEnabled || cfg.plugins.git.enable) [
      (mkPlugin pkgs.vimPlugins.gitsigns-nvim {
        config = "require('gitsigns').setup({})";
      })
      (mkPlugin pkgs.vimPlugins.vim-fugitive { })
    ]
    ++ lib.optionals (coreEnabled || cfg.plugins.whichKey.enable) [
      (mkPlugin pkgs.vimPlugins.which-key-nvim {
        config = "require('which-key').setup({})";
      })
    ]
    ++ lib.optionals (coreEnabled || cfg.plugins.indentBlankline.enable) [
      (mkPlugin pkgs.vimPlugins.indent-blankline-nvim {
        config = "require('ibl').setup({})";
      })
    ]
    ++ lib.optionals (coreEnabled || cfg.plugins.comment.enable) [
      (mkPlugin pkgs.vimPlugins.comment-nvim {
        config = "require('Comment').setup()";
      })
    ]
    ++ lib.optionals (coreEnabled || cfg.plugins.noice.enable) [
      nui
      devicons
      (mkPlugin pkgs.vimPlugins.noice-nvim {
        config = ''
          require('noice').setup({
            presets = { command_palette = true, long_message_to_split = true },
          })
        '';
      })
    ]
    ++ cfg.extraPlugins;

  # LSP/tooling installation based on toggles
  lspAll = cfg.langServers.enableAll;
  nodePkgs = pkgs.nodePackages_latest or pkgs.nodePackages;

  lspPkgs =
    lib.optionals (lspAll || cfg.langServers.rust.enable) [
      pkgs.rust-analyzer
      pkgs.rustc
      pkgs.cargo
    ]
    ++ lib.optionals (lspAll || cfg.langServers.lua.enable) [
      pkgs.lua-language-server
      pkgs.luajitPackages.luacheck
    ]
    ++ lib.optionals (lspAll || cfg.langServers.haskell.enable) [
      pkgs.haskellPackages.haskell-language-server
      pkgs.ghc
    ]
    ++ lib.optionals (lspAll || cfg.langServers.typescript.enable) [
      nodePkgs.typescript-language-server
      nodePkgs.typescript
      nodePkgs.eslint_d
    ]
    ++ lib.optionals (lspAll || cfg.langServers.python.enable) [
      pkgs.pyright
      pkgs.black
      pkgs.ruff
    ]
    ++ lib.optionals (lspAll || cfg.langServers.go.enable) [
      pkgs.gopls
      pkgs.go
    ]
    ++ lib.optionals (lspAll || cfg.langServers.nix.enable) [
      (pkgs.nil or pkgs.rnix-lsp)
      pkgs.nixpkgs-fmt
    ]
    ++ lib.optionals (lspAll || cfg.langServers.bash.enable) [ nodePkgs.bash-language-server ];

  # Provider runtimes for Neovim: node + python host
  providerPkgs = [
    pkgs.nodejs
    (pkgs.python3.withPackages (ps: [ ps.pynvim ]))
  ];

  # Compose extra Lua configs (from files and raw strings)
  extraLuaFromFiles = lib.concatStringsSep "\n" (
    map (path: ''
      lua << 'EOF'
      ${builtins.readFile path}
      EOF
    '') cfg.extraLuaFiles
  );

  extraLuaInline = lib.concatStringsSep "\n" (
    map (chunk: ''
      lua << 'EOF'
      ${chunk}
      EOF
    '') cfg.extraLuaChunks
  );

in
{
  options.modules.nvf = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Neovim with NVF-style plugin/LSP toggles via Home Manager.";
    };

    # Nightly via global overlay (ensure inputs.neovim-nightly-overlay.overlays.default is in mkPkgs)
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.neovim;
      description = "Neovim package (pkgs.neovim; nightly when overlay is applied globally).";
    };

    # Add extra HM modules to import (e.g., your NVF submodules)
    extraModules = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "Additional Home Manager modules to import and merge (NVF-style).";
    };

    # Extra plugins and Lua config
    extraPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      description = "Additional plugin attrsets appended to programs.neovim.plugins.";
    };

    # Single big extra Lua (kept for convenience)
    extraLuaConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra Lua configuration appended to init via extraConfig.";
    };

    # New: multiple Lua files and inline chunks
    extraLuaFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "List of Lua files to embed into init (in order).";
    };

    extraLuaChunks = lib.mkOption {
      type = lib.types.listOf lib.types.lines;
      default = [ ];
      description = "List of inline Lua chunks to embed into init (in order).";
    };

    plugins = {
      enableAll = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable all core IDE plugins.";
      };
      telescope.enable = lib.mkEnableOption "telescope.nvim";
      treesitter.enable = lib.mkEnableOption "nvim-treesitter";
      lsp.enable = lib.mkEnableOption "nvim-lspconfig";
      cmp.enable = lib.mkEnableOption "nvim-cmp + sources";
      nullLs.enable = lib.mkEnableOption "null-ls";
      git.enable = lib.mkEnableOption "gitsigns + fugitive";
      whichKey.enable = lib.mkEnableOption "which-key";
      indentBlankline.enable = lib.mkEnableOption "indent-blankline";
      comment.enable = lib.mkEnableOption "comment.nvim";
      noice.enable = lib.mkEnableOption "noice.nvim";
    };

    langServers = {
      enableAll = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Install all LSPs/tools.";
      };
      rust.enable = lib.mkEnableOption "Rust";
      lua.enable = lib.mkEnableOption "Lua";
      haskell.enable = lib.mkEnableOption "Haskell";
      typescript.enable = lib.mkEnableOption "TypeScript/JavaScript";
      python.enable = lib.mkEnableOption "Python";
      go.enable = lib.mkEnableOption "Go";
      nix.enable = lib.mkEnableOption "Nix";
      bash.enable = lib.mkEnableOption "Bash";
    };
  };

  # Import any extra HM modules provided via NVF options
  imports = cfg.extraModules;

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      package = cfg.package;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = plugins;

      extraPackages = providerPkgs;

      # Combine extraLuaConfig + files + chunks (in order)
      extraConfig = lib.concatStringsSep "\n" (
        lib.filter (s: s != "") [
          (lib.optionalString (cfg.extraLuaConfig != "") ''
            lua << 'EOF'
            ${cfg.extraLuaConfig}
            EOF
          '')
          extraLuaFromFiles
          extraLuaInline
        ]
      );
    };

    home.packages = [
      pkgs.git
      pkgs.ripgrep
      pkgs.fd
      pkgs.tree-sitter
    ]
    ++ lspPkgs;
  };
}
