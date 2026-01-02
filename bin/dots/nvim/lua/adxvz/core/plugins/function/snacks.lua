-- lua/adxvz/config/snacks.lua

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = { "nvim-mini/mini.nvim", version = false },
	opts = {
		bufdelete = { enabled = true },
		dashboard = {
			enabled = true,
			header = {
				"                                          ",
				"  █████╗ ██████╗ ██╗  ██╗██╗   ██╗███████╗",
				" ██╔══██╗██╔══██╗╚██╗██╔╝██║   ██║╚══███╔╝",
				" ███████║██║  ██║ ╚███╔╝ ██║   ██║  ███╔╝ ",
				" ██╔══██║██║  ██║ ██╔██╗ ╚██╗ ██╔╝ ███╔╝  ",
				" ██║  ██║██████╔╝██╔╝ ██╗ ╚████╔╝ ███████╗",
				" ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝  ╚═══╝  ╚══════╝",
				"                                          ",
			},
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
				{
					icon = " ",
					key = "c",
					desc = "Config",
					action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
				},
				{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
				{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},

		explorer = {
			enabled = true,
			layout = "sidebar",
			width = 35,
		},

		gh = {
			enabled = true,
			default_remote = "origin",
		},

		git = {
			enabled = true,
			signs = true,
			blame = true,
		},

		gitbrowse = {
			enabled = true,
		},

		image = {
			enabled = true,
			inline = true,
		},

		indent = {
			enabled = true,
			scope = {
				enabled = true,
				highlight = "SnacksIndentScope",
				priority = 2000,
			},
		},

		keymap = { enabled = true },

		layout = {
			enabled = true,
			cycle = true,
		},

		notifier = {
			enabled = true,
			timeout = 3000,
			history = 50,
		},

		notify = {
			enabled = true,
			level = vim.log.levels.INFO,
		},

		picker = {
			enabled = true,
			layout = "custom",
			layouts = {
				custom = {
					layout = {
						box = "vertical",
						backdrop = false,
						row = -1,
						width = 0,
						height = 0.4,
						border = "none",
						title = " {title} {live} {flags}",
						title_pos = "left",
						{
							box = "horizontal",
							{ win = "list", border = "rounded" },
							{ win = "preview", title = "{preview}", width = 0.6, border = "rounded" },
						},
						{ win = "input", height = 1, border = "top" },
					},
				},
			},
			projects = {
				dev = { "~/Developer" },
				recent = true,
			},
		},

		rename = {
			enabled = true,
			popup = true,
		},

		scratch = {
			enabled = true,
			persist = true,
		},

		scroll = {
			enabled = true,
			duration = 150,
		},

		scope = {
			enable = true,
			keymaps = {
				goto_scope_start = "<leader>ss",
				goto_scope_end = "<leader>se",
			},
			highlight = {
				enable = true,
				style = "underline",
				hl_group = "Visual",
			},
		},

		statuscolumn = {
			enabled = true,
			left = { "mark", "sign" }, -- mark, sign columns on the left
			right = { "fold", "git" }, -- fold, git on the right
			folds = {
				open = false, -- show only folded state
				git_hl = true, -- use git highlight for fold icons
			},
			git = {
				patterns = { "GitSign", "MiniDiffSign" },
			},
		},

		terminal = {
			enabled = true,
			direction = "float",
		},

		toggle = {
			enabled = true,
		},

		util = { enabled = true },

		win = {
			enabled = true,
		},

		words = {
			enabled = true,
			highlight = "Search",
		},
		dashboard = {
			enabled = true,
		},
		styles = {
			notification = {},
			input = {
				backdrop = false,
				relative = "editor",
				border = true,
				title_pos = "center",
				position = "float",
				row = 2,
				width = 60,
				height = 1,
				wo = {
					winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
					cursorline = false,
				},
				bo = {
					filetype = "snacks_input",
					buftype = "prompt",
				},
				b = { completion = false },
			},
		},
	},
	-- Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
	-- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
	-- Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
	-- Snacks.toggle.diagnostics():map("<leader>ud")
	-- Snacks.toggle.line_number():map("<leader>ul")
	-- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
	-- Snacks.toggle.treesitter():map("<leader>uT")
	-- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
	-- Snacks.toggle.inlay_hints():map("<leader>uh")
	-- Snacks.toggle.indent():map("<leader>ug")
	-- Snacks.toggle.dim():map("<leader>uD")
}
