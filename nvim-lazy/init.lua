-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.neovide then
  vim.o.guifont = "Monaspace Neon Var:h17"
  vim.g.neovide_cursor_trail_size = 0.2
  vim.g.neovide_animation_length = 0.05
  vim.g.neovide_scroll_animation_far_lines = 0
end
