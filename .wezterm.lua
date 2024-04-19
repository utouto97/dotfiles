local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.7
config.font = wezterm.font("Cica")
-- config.font = wezterm.font('HackGen35 Console NF')

return config
