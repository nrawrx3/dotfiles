local wezterm = require("wezterm")

local config = wezterm.config_builder()

local act = wezterm.action

local color_schemes = {
	"Pulp (terminal.sexy)",
	"Selenized Dark (Gogh)",
	"Selenized Light (Gogh)",
}

local fonts = {
	{
		face = "SF Mono",
		style = { weight = "Medium", italic = false },
		size = 16,
	},

	{
		face = "MonaspiceAr Nerd Font",
		style = { weight = "Medium", italic = false },
		size = 16,
	},
}

local current_scheme_index = 1 -- Start with the first scheme

local function cycle_color_scheme(window)
	-- Increment the index, wrapping around if necessary
	current_scheme_index = current_scheme_index % #color_schemes + 1
	local next_scheme = color_schemes[current_scheme_index]

	-- Apply the next color scheme to the current window
	window:set_config_overrides({ color_scheme = next_scheme })
end

local current_font_index = 1 -- Start with the first scheme

local function cycle_font_config(window)
	-- Increment the index, wrapping around if necessary
	current_font_index = current_font_index % #fonts + 1
	local next_font = fonts[current_font_index]

	-- Apply the next color scheme to the current window
	window:set_config_overrides({ font = wezterm.font(next_font.face, next_font.style) })
	window:set_config_overrides({ font_size = next_font.size })
end

-- config.color_scheme = "Pulp (terminal.sexy)"
config.color_scheme = color_schemes[1]

local font = ""
-- font = "Iosevkiss Extended"
font = "BlexMono Nerd Font"

config.font = wezterm.font(font, { italic = false, weight = "Medium" })
config.font_size = 15

-- Here's the juice for the split panes functionality
config.keys = {
	-- Split vertically (new pane to the right)
	{ key = "d", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Split horizontally (new pane to the bottom)
	{ key = "d", mods = "ALT|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- Move focus between panes
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	-- Adjusting this to close the current pane
	{ key = "w", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	-- Cycle focus between panes with ALT+]
	{ key = "]", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Next") },

	-- Clear scrollback and reset viewport
	{ key = "k", mods = "ALT", action = act.ClearScrollback("ScrollbackAndViewport") },
	-- Add a key binding for ALT+Shift+Backslash to cycle the color scheme
	{
		key = ",",
		mods = "ALT",
		action = wezterm.action_callback(cycle_font_config),
	},
	{
		key = ".",
		mods = "ALT",
		action = wezterm.action_callback(cycle_color_scheme),
	},
}

config.audible_bell = "Disabled"

-- config.window_background_opacity = 0.97

wezterm.on("augment-command-palette", function(window, pane)
	return {
		{
			brief = "Luvboard Dev Workspace",
			icon = "md_application_brackets",
			action = wezterm.action_callback(function(window, pane)
				local project_dir = "/home/soumik/werk/luvboard"
				local mux_win = window:mux_window()

				-- Tab 1 (current): ADB logs split left/right
				pane:send_text("cd " .. project_dir .. "\n")
				pane:send_text("./scripts/apk-helper.py --logs Poco\n")
				local logs_right = pane:split({
					direction = "Right",
					size = 0.5,
					cwd = project_dir,
				})
				logs_right:send_text("./scripts/apk-helper.py --logs Nothing\n")

				-- Tab 2: Firebase emulator (source utils then run)
				local tab2, emu_pane, _ = mux_win:spawn_tab({
					cwd = project_dir,
				})
				emu_pane:send_text("source ./utils.source.fish; run_emulator_with_data\n")

				-- Tab 3: Scrcpy split left/right
				local tab3, scrcpy_left, _ = mux_win:spawn_tab({
					cwd = project_dir,
				})
				scrcpy_left:send_text("./scripts/apk-helper.py --scrcpy poco\n")
				local scrcpy_right = scrcpy_left:split({
					direction = "Right",
					size = 0.5,
					cwd = project_dir,
				})
				scrcpy_right:send_text("./scripts/apk-helper.py --scrcpy Nothing\n")

				-- Focus back to the logs tab
				window:perform_action(act.ActivateTab(0), pane)
			end),
		},
	}
end)

return config
