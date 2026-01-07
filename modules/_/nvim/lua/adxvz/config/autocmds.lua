-- lua/adxvz/config/autocmds.lua

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        local Snacks = require("snacks")

        -- global debug helpers
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end

        if vim.fn.has("nvim-0.11") == 1 then
            vim._print = function(_, ...) dd(...) end
        else
            vim.print = _G.dd
        end
    end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
      if event.data.actions[1].type == "move" then
          Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
      end
  end,
})
