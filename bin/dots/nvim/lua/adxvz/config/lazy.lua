----------------------------------------------------------------
-- Installation and Configuration of lazy.nvim Plugin Manager
-- https://github.com/folke/lazy.nvim.git
----------------------------------------------------------------

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)


-- Setup lazy.nvim
require("lazy").setup({

    spec = {
        -- import your plugins
        { import = "adxvz.core.plugins.form" },
        { import = "adxvz.core.plugins.function" },
    },
    install = {
        colorscheme = { "kanagawa" }, -- colorscheme that will be used when installing plugins.
        missing = true,               -- install missing plugins on startup. This doesn't increase startup time.
    },
    checker = {
        enabled = true, -- automatically check for plugin updates
        notify = true,  -- get a notification when changes are found
    },
    change_detection = {
        enabled = true, -- automatically check for config file changes and reload the ui
        notify = true,  -- get a notification when changes are found
    },
})
