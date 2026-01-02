local w = require("wezterm")
local config = {}

-- Provides clearer error messages
if w.config_builder then
    config = w.config_builder()
end

-- Appearance
-- Color scheme
local kanagawa = {
    foreground = "#dcd7ba",
    background = "#1b1b23",

    cursor_bg = "#9CABCA",
    cursor_fg = "#252535",
    cursor_border = "#c8c093",

    selection_fg = "#c8c093",
    selection_bg = "#2d4f67",

    scrollbar_thumb = "#16161d",
    split = "#16161d",

    ansi = { "#090618", "#c34043", "#98BB6C", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
    brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
    indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
}
local palenightfall = {
    foreground = "#959DCB",
    background = "#252837",

    cursor_bg = "#82AAff",
    cursor_fg = "#252535",
    cursor_border = "#c8c093",

    selection_fg = "#292D3E",
    selection_bg = "#959DCB",

    scrollbar_thumb = "#16161d",
    split = "#4e5579",

    ansi = { "#252837", "#F07178", "#C3E88D", "#FFCB6B", "#82AAFF", "#C792EA", "#89DDFF", "#7982B4" },
    brights = { "#4e5579", "#FF8B92", "#DDFFA7", "#FFE585", "#9CC4FF", "#E1ACFF", "#A3F7FF", "#FFFFFF" },
}
config.color_schemes = {
    ["Kanagawa"] = kanagawa,
    ["Palenightfall"] = palenightfall,
}
config.color_scheme = "Kanagawa"

config.colors = {
    tab_bar = {
        background = '#191920',

        active_tab = {
            bg_color = '#FFCB20',
            fg_color = '#1F1F28',
            intensity = 'Bold',
            underline = 'None',
            italic = false,
            strikethrough = false,
        },

        inactive_tab = {
            bg_color = '#363645',
            fg_color = '#B4AD88',
        },

        inactive_tab_hover = {
            bg_color = '#363645',
            fg_color = '#909090',
            italic = true,
        },

        new_tab = {
            bg_color = '#191920',
            fg_color = '#808080',
        },

        new_tab_hover = {
            bg_color = '#3b3052',
            fg_color = '#909090',
            italic = true,
        },
    },
}

-- Font
--config.font = w.font("JetBrains Nerd Font", { weight = "Medium" })
config.font_size = 14
config.strikethrough_position = "0.5cell"
config.adjust_window_size_when_changing_font_size = false

-- Window Pane
config.window_padding = {
    left = "4cell",
    right = "4cell",
    top = "2cell",
    bottom = "1cell",
}

config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.max_fps = 120
config.inactive_pane_hsb = {
    brightness = 0.3,
    saturation = 0.6,
}

config.window_background_opacity = 0.9
config.text_background_opacity = 1.0
config.macos_window_background_blur = 25

--- Behaviour
config.scrollback_lines = 10000
config.window_close_confirmation = "NeverPrompt"
config.initial_rows = 40
config.initial_cols = 200

-- Tmux Functionality
config.leader = { key = "z", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
    {
        mods = "LEADER",
        key = "c",
        action = w.action.SpawnTab "CurrentPaneDomain",
    },
    {
        mods = "LEADER",
        key = "x",
        action = w.action.CloseCurrentPane { confirm = true }
    },
    {
        mods = "LEADER",
        key = "<",
        action = w.action.ActivateTabRelative(-1)
    },
    {
        mods = "LEADER",
        key = ">",
        action = w.action.ActivateTabRelative(1)
    },
    {
        mods = "LEADER",
        key = "b",
        action = w.action.SplitHorizontal { domain = "CurrentPaneDomain" }
    },
    {
        mods = "LEADER",
        key = "v",
        action = w.action.SplitVertical { domain = "CurrentPaneDomain" }
    },
    {
        mods = "LEADER",
        key = "h",
        action = w.action.ActivatePaneDirection "Left"
    },
    {
        mods = "LEADER",
        key = "j",
        action = w.action.ActivatePaneDirection "Down"
    },
    {
        mods = "LEADER",
        key = "k",
        action = w.action.ActivatePaneDirection "Up"
    },
    {
        mods = "LEADER",
        key = "l",
        action = w.action.ActivatePaneDirection "Right"
    },
    {
        mods = "LEADER",
        key = "LeftArrow",
        action = w.action.AdjustPaneSize { "Left", 5 }
    },
    {
        mods = "LEADER",
        key = "RightArrow",
        action = w.action.AdjustPaneSize { "Right", 5 }
    },
    {
        mods = "LEADER",
        key = "DownArrow",
        action = w.action.AdjustPaneSize { "Down", 5 }
    },
    {
        mods = "LEADER",
        key = "UpArrow",
        action = w.action.AdjustPaneSize { "Up", 5 }
    },
    {
        mods = "LEADER",
        key = "o",
        action = w.action.ToggleAlwaysOnTop
    },
}

for i = 0, 9 do
    -- leader + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = w.action.ActivateTab(i),
    })
end

-- Tab Bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true



return config
