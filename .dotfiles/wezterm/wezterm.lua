local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config = {
    enable_tab_bar = false,
    window_background_opacity = 1,
    window_decorations = "RESIZE",
    automatically_reload_config = true,
    window_close_confirmation = "NeverPrompt",
    color_scheme = 'rose-pine-moon',
    font = wezterm.font("JetBrains Mono", {weight = "Bold"}),
    font_size = 15,
}
return config
