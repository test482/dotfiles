-- https://wezfurlong.org/wezterm/config/files.html

local wezterm = require 'wezterm'

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local edge_background = "#333333"
    local background = "#666666"
    local foreground = "#eaeaea"

    if tab.is_active then
        background = "#7aa6da"
        foreground = "#ffffff"
    elseif hover then
        background = "#7aa6da"
        foreground = "#aaaaaa"
    end

    local edge_foreground = background

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    local title = tab.active_pane.title .. ' '
    local hostname = wezterm.hostname()
    -- emit current host
    local has_hostname = title:find(hostname)
    if has_hostname ~= nil then
        x, y = has_hostname
        title = wezterm.truncate_left(title, title:len() - x - hostname:len() - 1)
    end
    if string.len(title) + string.len(tab.tab_index) > max_width then
        title = wezterm.truncate_right(title, max_width - 5) .. "…"
    end

    return {
        { Background = { Color = edge_foreground } },
        { Foreground = { Color = edge_background } },
        { Text = SOLID_RIGHT_ARROW .. (tab.tab_index + 1) },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = SOLID_RIGHT_ARROW },
    }
end)

local keys = {
    { key = '=',          mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-',          mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'c',          mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    { key = 'LeftArrow',  mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'DownArrow',  mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
    { key = 'n',          mods = 'LEADER', action = wezterm.action.ActivateTabRelativeNoWrap(1) },
    { key = 'p',          mods = 'LEADER', action = wezterm.action.ActivateTabRelativeNoWrap(-1) },
    { key = 'w',          mods = 'LEADER', action = wezterm.action.CloseCurrentTab { confirm = true } },
    -- Send 'CTRL-B' to the terminal when pressing CTRL-B, CTRL-B
    { key = 'b',          mods = 'LEADER', action = wezterm.action.SendString '\x02' },
}

for i = 1, 9 do
    local tabkey = { key = tostring(i), mods = 'LEADER', action = wezterm.action.ActivateTab(i - 1) }
    table.insert(keys, tabkey)
end

local ctrlkeys = {}
for i, key in ipairs(keys) do
    local ctrlkey = { key = key.key, mods = key.mods .. '|CTRL', action = key.action }
    table.insert(ctrlkeys, ctrlkey)
    table.insert(ctrlkeys, key)
end

local config = {
    automatically_reload_config = false,

    -- visual
    color_scheme = 'Breeze',
    window_background_opacity = 1.0,

    -- tab_bar
    enable_scroll_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    tab_max_width = 32,
    use_fancy_tab_bar = false, -- 经典tab栏（矮小一些）

    -- font
    font_size = 12.0,
    font = wezterm.font_with_fallback {
        'Hack Nerd Font Mono',
        'Noto Sans CJK SC'
    },

    -- width & height
    initial_cols = 96,
    initial_rows = 32,

    -- cursors
    default_cursor_style = "BlinkingBar",
    cursor_blink_rate = 500,

    key_map_preference = "Mapped",
    -- tmux style key binding
    leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 },
    keys = ctrlkeys,
    disable_default_mouse_bindings = false,
    mouse_bindings = {
        {
            -- 左键选中只起到框选作用
            mods = "NONE",
            event = { Up = { streak = 1, button = "Left" } },
            action = wezterm.action.Nop,
        },
        {
            -- 单击右键：如果有选中，则复制；未选中则从剪贴板粘贴
            mods = "NONE",
            event = { Down = { streak = 1, button = "Right" } },
            action = wezterm.action_callback(function(window, pane)
                local has_selection = window:get_selection_text_for_pane(pane) ~= ""
                if has_selection then
                    window:perform_action(wezterm.action.CopyTo("ClipboardAndPrimarySelection"), pane)
                    window:perform_action(wezterm.action.ClearSelection, pane)
                else
                    window:perform_action(wezterm.action({ PasteFrom = "Clipboard" }), pane)
                end
            end),
        },
        {
            -- 按住 Ctrl 时再打开超链接
            mods = 'CTRL',
            event = { Up = { streak = 1, button = 'Left' } },
            action = wezterm.action.OpenLinkAtMouseCursor,
        },
    },
}

return config
