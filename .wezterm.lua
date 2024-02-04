local wezterm = require("wezterm")

local config = wezterm.config_builder()

local act = wezterm.action

config.default_prog = {"/opt/homebrew/bin/bash"}

config.color_scheme = 'Kanagawa (Gogh)'
config.font = wezterm.font("Gopher Mono", {weight="Regular", italic=false})
config.font_size = 16

-- Here's the juice for the split panes functionality
config.keys = {
  -- Split vertically (new pane to the right)
  {key="d", mods="CMD", action=wezterm.action.SplitHorizontal{domain="CurrentPaneDomain"}},
  -- Split horizontally (new pane to the bottom)
  {key="d", mods="CMD|SHIFT", action=wezterm.action.SplitVertical{domain="CurrentPaneDomain"}},
  -- Move focus between panes
  {key="h", mods="CMD", action=wezterm.action.ActivatePaneDirection("Left")},
  {key="l", mods="CMD", action=wezterm.action.ActivatePaneDirection("Right")},
  {key="k", mods="CMD", action=wezterm.action.ActivatePaneDirection("Up")},
  {key="j", mods="CMD", action=wezterm.action.ActivatePaneDirection("Down")},
  -- Adjusting this to close the current pane
  {key="w", mods="CMD", action=wezterm.action.CloseCurrentPane{confirm=true}},
  -- Cycle focus between panes with CMD+]
  {key="]", mods="CMD", action=wezterm.action.ActivatePaneDirection("Next")},

  -- Clear scrollback and reset viewport
  {key="k", mods = 'CMD', action = act.ClearScrollback 'ScrollbackAndViewport'},
}

config.window_background_opacity = 0.97

return config
