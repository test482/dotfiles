local wezterm = require 'wezterm'
local act = wezterm.action

return {
    keys = {
        { key = 'LeftArrow',  mods = 'SHIFT|ALT', action = act.MoveTabRelative(-1) },
        { key = 'RightArrow', mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
    },

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
                    window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
                end
            end),
        },
        {
            -- 按住 Ctrl 时再打开超链接
            mods = 'CTRL',
            event = { Up = { streak = 1, button = 'Left' } },
            action = act.OpenLinkAtMouseCursor,
        },
    }
}
