-- https://wezfurlong.org/wezterm/config/files.html

local wezterm = require 'wezterm'

local config = {}

config.automatically_reload_config = false

-- config.color_scheme = 'nord'
local themes = { 'Breeze', 'GitHub Dark', 'idea', 'nord' }
config.color_scheme = themes[math.random(#themes)]

config.font_size = 12.0
config.font = wezterm.font_with_fallback {
    'Hack Nerd Font Mono',
    'Noto Sans CJK SC'
}

config.initial_cols = 96               -- width
config.initial_rows = 32               -- height

config.window_background_opacity = 1.0 -- 不透明度

config.default_cursor_style = "SteadyBar"

-- keybinds
config.disable_default_mouse_bindings = false
config.mouse_bindings = require("keybinds").mouse_bindings
config.keys = require("keybinds").keys

config.use_fancy_tab_bar = false -- 经典tab栏（矮小一些）
config.hide_tab_bar_if_only_one_tab = true

return config
