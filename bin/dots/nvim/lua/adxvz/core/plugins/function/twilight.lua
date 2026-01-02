-- dim unused sections of code

return {
    "folke/twilight.nvim",
    opts = function(_, opts)
        opts.dimming = {
            alpha = 0.10, -- amount of dimming
            -- we try to get the foreground from the highlight groups or fallback color
            color = { "Normal", "#ffffff" },
            term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
        }
        opts.treesitter = true -- use treesitter when available for the filetype
        opts.context = 6
        opts.expand = {        -- for treesitter, we we always try to expand to the top-most ancestor with these types
            "function",
            "method",
            "table",
            "if_statement",
        }
        opts.exclude = {} -- exclude these filetypes
    end,
}
