-- https://wezfurlong.org/wezterm/config/files.html

local wezterm = require 'wezterm'
local act = wezterm.action

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
    { key = '%',          mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '"',          mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '\\',         mods = 'LEADER',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-',          mods = 'LEADER',       action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = "z",          mods = "LEADER",       action = act.TogglePaneZoomState },

    { key = 'LeftArrow',  mods = 'LEADER',       action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'LEADER',       action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = 'LEADER',       action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow',  mods = 'LEADER',       action = act.ActivatePaneDirection 'Down' },
    { key = "h",          mods = "LEADER",       action = act.ActivatePaneDirection 'Left' },
    { key = "j",          mods = "LEADER",       action = act.ActivatePaneDirection 'Down' },
    { key = "k",          mods = "LEADER",       action = act.ActivatePaneDirection 'Up' },
    { key = "l",          mods = "LEADER",       action = act.ActivatePaneDirection 'Right' },

    { key = 'c',          mods = 'LEADER',       action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'n',          mods = 'LEADER',       action = act.ActivateTabRelativeNoWrap(1) },
    { key = 'p',          mods = 'LEADER',       action = act.ActivateTabRelativeNoWrap(-1) },
    { key = 'x',          mods = 'LEADER',       action = act.CloseCurrentTab { confirm = true } },

    { key = "[",          mods = "LEADER",       action = act.ActivateCopyMode },
    { key = "]",          mods = "LEADER",       action = act.PasteFrom("PrimarySelection") },

    -- Send 'CTRL-B' to the terminal when pressing CTRL-B, CTRL-B
    { key = 'b',          mods = 'LEADER',       action = act.SendString '\x02' },
}

for i = 1, 9 do
    local tabkey = { key = tostring(i), mods = 'LEADER', action = act.ActivateTab(i - 1) }
    table.insert(keys, tabkey)
end

local ctrlkeys = {}
for i, key in ipairs(keys) do
    local ctrlkey = { key = key.key, mods = key.mods .. '|CTRL', action = key.action }
    table.insert(ctrlkeys, ctrlkey)
    table.insert(ctrlkeys, key)
end

local key_tables = {
    copy_mode = {
        { key = "q",          mods = "NONE",  action = act.CopyMode("Close") },
        { key = "Escape",     mods = "NONE",  action = act.CopyMode("Close") },

        { key = "h",          mods = "NONE",  action = act.CopyMode("MoveLeft") },
        { key = "j",          mods = "NONE",  action = act.CopyMode("MoveDown") },
        { key = "k",          mods = "NONE",  action = act.CopyMode("MoveUp") },
        { key = "l",          mods = "NONE",  action = act.CopyMode("MoveRight") },

        { key = "LeftArrow",  mods = "NONE",  action = act.CopyMode("MoveLeft") },
        { key = "DownArrow",  mods = "NONE",  action = act.CopyMode("MoveDown") },
        { key = "UpArrow",    mods = "NONE",  action = act.CopyMode("MoveUp") },
        { key = "RightArrow", mods = "NONE",  action = act.CopyMode("MoveRight") },

        { key = "RightArrow", mods = "ALT",   action = act.CopyMode("MoveForwardWord") },
        { key = "f",          mods = "ALT",   action = act.CopyMode("MoveForwardWord") },
        { key = "LeftArrow",  mods = "ALT",   action = act.CopyMode("MoveBackwardWord") },
        { key = "b",          mods = "ALT",   action = act.CopyMode("MoveBackwardWord") },

        { key = "g",          mods = "NONE",  action = act.CopyMode("MoveToViewportTop") },
        { key = "g",          mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },

        { key = "Enter",      mods = "NONE",  action = act.CopyMode("MoveToStartOfNextLine") },
        { key = "0",          mods = "NONE",  action = act.CopyMode("MoveToStartOfLine") },
        { key = "Home",       mods = "NONE",  action = act.CopyMode("MoveToStartOfLine") },
        { key = "End",        mods = "NONE",  action = act.CopyMode("MoveToEndOfLineContent") },

        { key = " ",          mods = "NONE",  action = act.CopyMode { SetSelectionMode = "Cell" } },
        { key = "v",          mods = "NONE",  action = act.CopyMode { SetSelectionMode = "Cell" } },
        { key = "v",          mods = "SHIFT", action = act.CopyMode { SetSelectionMode = "Line" } },
        { key = "v",          mods = "CTRL",  action = act.CopyMode { SetSelectionMode = "Block" } },

        { key = "PageUp",     mods = "NONE",  action = act.CopyMode("PageUp") },
        { key = "PageDown",   mods = "NONE",  action = act.CopyMode("PageDown") },

        -- Enter y to copy and quit the copy mode.
        {
            key = "y",
            mods = "NONE",
            action = act.Multiple {
                act.CopyTo("ClipboardAndPrimarySelection"),
                act.CopyMode("Close"),
            }
        },
        {
            key = "c",
            mods = "CTRL",
            action = act.Multiple {
                act.CopyTo("ClipboardAndPrimarySelection"),
                act.CopyMode("Close"),
            }
        },
        -- Enter search mode to edit the pattern.
        -- When the search pattern is an empty string the existing pattern is preserved
        { key = "/", mods = "NONE", action = act { Search = { CaseSensitiveString = "" } } },
        { key = "?", mods = "NONE", action = act { Search = { CaseInSensitiveString = "" } } },
        { key = "n", mods = "NONE", action = act { CopyMode = "NextMatch" } },
        { key = "p", mods = "NONE", action = act { CopyMode = "PriorMatch" } },
    },
    search_mode = {
        -- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
        -- to navigate search results without conflicting with typing into the search area.
        { key = "Escape",    mods = "NONE", action = act.ActivateCopyMode },
        { key = "Enter",     mods = "NONE", action = act.ActivateCopyMode },
        { key = "n",         mods = "CTRL", action = act { CopyMode = "NextMatch" } },
        { key = "p",         mods = "CTRL", action = act { CopyMode = "PriorMatch" } },
        { key = "r",         mods = "CTRL", action = act.CopyMode("CycleMatchType") },
        { key = "Backspace", mods = "CTRL", action = act.CopyMode("ClearPattern") },
    },
}

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
    key_tables = key_tables,
    disable_default_mouse_bindings = false,
    mouse_bindings = {
        {
            -- 左键选中只起到框选作用
            mods = "NONE",
            event = { Up = { streak = 1, button = "Left" } },
            action = act.Nop,
        },
        {
            -- 单击右键：如果有选中，则复制；未选中则从剪贴板粘贴
            mods = "NONE",
            event = { Down = { streak = 1, button = "Right" } },
            action = wezterm.action_callback(function(window, pane)
                local has_selection = window:get_selection_text_for_pane(pane) ~= ""
                if has_selection then
                    window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
                    window:perform_action(act.ClearSelection, pane)
                else
                    window:perform_action(wezterm.action({ PasteFrom = "Clipboard" }), pane)
                end
            end),
        },
        {
            -- 按住 Ctrl 时再打开超链接
            mods = 'CTRL',
            event = { Up = { streak = 1, button = 'Left' } },
            action = act.OpenLinkAtMouseCursor,
        },
    },
}

return config
