-- Ultra fold tool for neovim

return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    event = "BufReadPost",
    config = function()
        -- Recommended fold settings
        vim.o.foldcolumn = "1"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        -- Setup UFO
        require("ufo").setup({
            provider_selector = function(_, filetype, _)
                -- Treesitter first, then indent, fallback to LSP
                if filetype == "lua" then
                    return { "treesitter", "indent" }
                end
                return { "lsp", "indent" }
            end,
        })
    end,
}
