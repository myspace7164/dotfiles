local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.enable_tab_bar = false

config.window_padding = {
	left = 2,
	right = 2,
	top = 0,
	bottom = 0,
}

config.font = wezterm.font("Iosevka")
config.font_size = 10

config.color_scheme = "Modus-Vivendi"

return config

