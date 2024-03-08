local wezterm = require("wezterm")

local config = wezterm.config_builder()

local act = wezterm.action

config.default_prog = { "/opt/homebrew/bin/bash" }

local color_schemes = {
        "Kanagawa (Gogh)",
        "Navy and Ivory (terminal.sexy)",
        "Sandcastle (base16)"
}

local fonts = {
        {
                face = "Monaspace Argon Var",
                style = { weight = "Medium", italic = false },
                size = 16
        },

        {
                face = "Gopher Mono",
                style = { weight = "Medium", italic = false },
                size = 16
        },
}

local current_scheme_index = 1 -- Start with the first scheme

local function cycle_color_scheme(window)
  -- Increment the index, wrapping around if necessary
  current_scheme_index = current_scheme_index % #color_schemes + 1
  local next_scheme = color_schemes[current_scheme_index]

  -- Apply the next color scheme to the current window
  window:set_config_overrides({color_scheme = next_scheme})
end

local current_font_index = 1 -- Start with the first scheme

local function cycle_font_config(window)
  -- Increment the index, wrapping around if necessary
  current_font_index = current_font_index % #fonts + 1
  local next_font = fonts[current_font_index]

  -- Apply the next color scheme to the current window
  window:set_config_overrides({font = wezterm.font(next_font.face, next_font.style)})
  window:set_config_overrides({font_size = next_font.size})
end


config.color_scheme = "Kanagawa (Gogh)"

-- config.color_scheme = "Navy and Ivory (terminal.sexy)"
config.font = wezterm.font("Monaspace Neon Var", { weight = "Medium", italic = false })
config.font_size = 16

-- Here's the juice for the split panes functionality
config.keys = {
	-- Split vertically (new pane to the right)
	{ key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Split horizontally (new pane to the bottom)
	{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- Move focus between panes
	{ key = "h", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Down") },
	-- Adjusting this to close the current pane
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	-- Cycle focus between panes with CMD+]
	{ key = "]", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Next") },

	-- Clear scrollback and reset viewport
	{ key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },
         -- Add a key binding for CMD+Shift+Backslash to cycle the color scheme
        {
                key = ',',
                mods = 'CMD',
                action = wezterm.action_callback(cycle_font_config),
        },
        {
                key = '.',
                mods = 'CMD',
                action = wezterm.action_callback(cycle_color_scheme),
        },
}

config.audible_bell = "Disabled"

config.window_background_opacity = 0.97

return config
