
return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
        "nvim-tree/nvim-web-devicons",
        "nvim-treesitter/nvim-treesitter-textobjects",
        "RRethy/nvim-treesitter-endwise",
        "nvim-treesitter/nvim-treesitter-context",
        {
            "nvim-treesitter/playground",
            cmd = "TSPlaygroundToggle",
        },

        -- modern rainbow plugin
        {
            "HiPhish/rainbow-delimiters.nvim"
        },
    },

    config = function()
        local ts = require("nvim-treesitter.configs")

        ts.setup({
            highlight = {
                enable = true,
                disable = { "css", "markdown" },
                additional_vim_regex_highlighting = true,
            },

            indent = {
                enable = true,
                disable = { "yaml", "yml" },
            },

            autotag = {
                enable = true,
                disable = { "xml" },
            },

            autopairs = { enable = true },

            endwise = { enable = true },

            -- treesitter-context is configured separately; this enables its parsing
            context = { enable = true },

            ensure_installed = {
                "bash", "css", "comment", "dockerfile",
                "html", "javascript", "jq", "json",
                "latex", "lua", "markdown", "markdown_inline", "php",
                "python", "scss", "ssh_config",
                "sql", "terraform", "toml", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                   node_incremental = "<C-space>",
                   node_decremental = "<bs>",
                },
            },
        })

        -- Rainbow-delimiters setup (Lua table)
        require("rainbow-delimiters.setup").setup({
            strategy = {
                [""] = require("rainbow-delimiters").strategy["global"],
            },
        })
    end,
}
