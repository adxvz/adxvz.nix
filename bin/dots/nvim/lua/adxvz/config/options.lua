-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

local g = vim.g   -- Global variables
local o = vim.opt -- Set options (global/buffer/windows-scoped)


-----------------------------------------------------------
-- Global Variables
-----------------------------------------------------------

g.autoformat = true              -- LazyVim Autoformat
g.deprecation_warnings = true    -- Show deprecation warnings
g.markdown_recommended_style = 0 -- Fix markdown indentation settings
g.trouble_lualine = true         -- Show the current document symbols location from Trouble in lualine


-----------------------------------------------------------
-- General
-----------------------------------------------------------

o.clipboard:append("unnamedplus")                                -- Copy/paste to system clipboard
o.complete = { ".", "w", "b", "u", "t", "i", "kspell" }          -- This option specifies how keyword completion ins-completion works when CTRL-P or CTRL-N are used
o.completeopt = 'menuone,noinsert,noselect'                      -- Autocomplete options
o.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()" -- Auto formatting of LUA
o.grepprg = "rg --vimgrep --smart-case --"                       -- use rg instead of grep
o.grepformat = "%f:%l:%c:%m"                                     -- Format to recognize for the ":grep" command output
o.mouse = 'nv'                                                   -- Enable mouse support
o.sessionoptions = {                                             -- Restore nvim sessions using :mksession
    "buffers",
    "curdir",
    "tabpages",
    "winsize",
    "help",
    "globals",
    "skiprtp",
    "folds",
}
o.signcolumn =
"yes"                            -- Always show the signcolumn, otherwise it would shift the text each time
o.spelloptions =
"noplainbuffer"                  -- Only spellcheck a buffer when 'syntax' is enabled, or when extmarks are set within the buffer
o.swapfile = false               -- Don't use swapfile
o.virtualedit =
"block"                          -- Allow cursor to move where there is no text in visual block mode
o.winminwidth = 5                -- Minimum window width
o.wrap = false                   -- Disable line wrap
o.writebackup = true             -- create backup before overwriting file. Autoremove once file overwritten

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------

o.colorcolumn = '+1'                                     -- Highlight column after 'textwidth'
o.conceallevel = 2                                       -- so that `` is visible in markdown files
o.confirm = true                                         -- confirm to save changes before exiting modified buffer
o.cursorline = true                                      -- highlight the current line
o.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()" -- folds are automatically defined by their foldlevel
o.foldmethod = "expr"                                    -- specify an expression to define folds
o.foldtext =
""                                                       -- An expression which is used to specify the text displayed for a closed fold
o.laststatus = 3                                         -- Set global statusline
o.ignorecase = true                                      -- Ignore case letters when search
o.inccommand = "nosplit"                                 -- preview incremental substitute
o.linebreak = true                                       -- Wrap on word boundary
o.list = false                                           -- disable default listchars
o.listchars = {                                          -- replacement for listchars
    eol = "↲",
    tab = "→ ",
    trail = "+",
    extends = ">",
    precedes = "<",
    space = "·",
    nbsp = "␣",
}
o.number = true         -- Show line number
o.pumblend = 10         -- Popup blend
o.pumheight = 10        -- Maximum number of entries in a popup
o.relativenumber = true -- set relative numbered lines
o.scrolloff = 4         -- Minimal number of screen lines to keep above and below the cursor
o.sidescrolloff = 8     -- Minimal number of screen lines to keep horizontally
o.showmatch = true      -- Highlight matching parenthesis
o.showmode = false      -- Hides things like -- INSERT
o.smartcase = true      -- Don't ignore case with capitals
o.smoothscroll = true   -- Smooth scrolling
o.splitbelow = true     -- Horizontal split to the bottom
o.splitkeep = "screen"  -- Keep the text on the same screen line
o.splitright = true     -- Vertical split to the right
o.termguicolors = true  -- Enable 24-bit RGB colors
o.background = "dark"   -- Colorschemes with both light and dark modes will default to dark
-----------------------------------------------------------
-- Tabs, indent, formatting
-----------------------------------------------------------
o.expandtab = true               -- Use spaces instead of tabs
o.formatoptions = "jcroqlnt"     -- Lazy Autoformat
o.shiftround = true              -- Round indent
o.shiftwidth = 2                 -- The number of spaces inserted for each indentation
o.showtabline = 1                -- show tabs; 0 never, 1 only if at least two tab pages, 2 always
o.smartindent = true             -- Autoindent new lines
o.tabstop = 2                    -- 1 tab == 2 spaces
o.autoindent = true              -- Copies the indent from current line when starting a new one
o.backspace = "indent,eol,start" -- Allow backspace on indent, end of line or insert mode start position

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
o.hidden = true    -- Enable background buffers
o.history = 300    -- Remember N lines in history
o.synmaxcol = 240  -- Max column for syntax highlight
o.updatetime = 250 -- ms to wait for trigger an event



-----------------------------------------------------------
-- Wildcard
-----------------------------------------------------------

o.wildignorecase = true          -- When set case is ignored when completing file names and directories
o.wildmode = "longest:full,full" -- Command-line completion mode
o.winminwidth = 5                -- minimum window width
o.wildignore = [[
.git,.hg,.svn,
*.aux,*.out,*.toc
*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,
*.class,*.ai,*.bmp,*.gif,*.ico,*.jpg,
*.jpeg,*.png,*.psd,*.webp,
*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,
*.mkv,*.vob,*.mpg,*.mpeg
*.mp3,*.oga,*.ogg,*.wav,*.flac
*.eot,*.otf,*.ttf,*.woff
*.doc,*.pdf,*.cbr,*.cbz
*.zip,*.tar.gz,*.tar.bz2,*.rar,
*.tar.xz,*.kgb,
*.swp,.lock,.DS_Store,._*,
*/tmp/*,*.so,*.swp,*.zip,**/node_modules/**,
**/target/**,**.terraform/**"
]]

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------

-- Disable builtin plugins
local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "tutor",
    "rplugin",
    "synmenu",
    "optwin",
    "compiler",
    "bugreport",
    "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end
