local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- Reload Neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]]

-- Packer setup
require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- mini.nvim
	use 'echasnovski/mini.nvim'

	-- Automatically set up configuration after cloning packer.nvim
	if packer_bootstrap then
		require('packer').sync()
	end

	use {
		'akinsho/bufferline.nvim',
		tag = "*",
		requires = 'nvim-tree/nvim-web-devicons' -- for file icons
	}

	use 'hrsh7th/cmp-nvim-lsp'

	use 'hrsh7th/nvim-cmp' -- Autocompletion engine

	use {
		'nvim-telescope/telescope.nvim',
		requires = { 'nvim-lua/plenary.nvim' } -- Dependency for Telescope
	}

	use {
		'neovim/nvim-lspconfig', -- LSP configurations
	}

	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- For file icons (optional, but recommended)
		}
	}

	use {
		'greggh/claude-code.nvim',
		requires = {
			'nvim-lua/plenary.nvim', -- Required for git operations
		},
		config = function()
			require('claude-code').setup()
		end
	}
end)


-- mini.nvim modules


-- Load and configure mini.nvim modules
require('mini.indentscope').setup({
	symbol = '│', -- Customize this symbol
	options = { try_as_border = true }
})

require('mini.pairs').setup()

require('mini.comment').setup()

require('mini.statusline').setup()

require('mini.tabline').setup()

require('mini.files').setup()

require('mini.jump').setup()

require('mini.cursorword').setup()

-- Example customization for MiniTabline
require('mini.tabline').setup({
	show_icons = true,
	tabpage_section = 'right'
})

require('bufferline').setup({
	options = {
		mode = "buffers", -- Show buffer tabs
		numbers = "none", -- No buffer numbers
		diagnostics = "nvim_lsp", -- Show LSP diagnostics in the bufferline
		separator_style = "thin", -- Thin separator
		show_buffer_close_icons = false,
		show_close_icon = false,
		offsets = { { filetype = "NvimTree", text = "File Explorer", padding = 1 } },
		always_show_bufferline = true,
	}
})


local excluded_folders = { "node_modules", ".git", "build", "dist", "vendor" }

require('telescope').setup({
	defaults = {
		prompt_prefix = "🔍 ", -- Customize the prompt symbol
		selection_caret = "➤ ", -- Customize the selection caret
		sorting_strategy = "ascending", -- Sort results from top to bottom
		layout_config = {
			prompt_position = "top", -- Move the search bar to the top
		},
		mappings = {
			i = {
				["<C-j>"] = "move_selection_next", -- Navigate down
				["<C-k>"] = "move_selection_previous", -- Navigate up
				["<C-q>"] = "close" -- Close the picker
			},
		},
		vimgrep_arguments = vim.tbl_extend('force', require('telescope.config').values.vimgrep_arguments, {
			'--glob', '!' .. table.concat(excluded_folders, ',!')
		}),
		file_ignore_patterns = excluded_folders,
	}
})

-- colors

vim.cmd 'colorscheme minisummer'

-- Set recommended options for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Configure nvim-tree
require('nvim-tree').setup({
	view = {
		width = 30, -- Width of the file tree
		side = "left", -- Position: 'left' or 'right'
	},
	renderer = {
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
		},
	},
	actions = {
		open_file = {
			quit_on_open = true, -- Close tree when opening a file
		},
		remove_file = {
			close_window = false, -- Keep the window open after deleting a file
		},
	},
	git = {
		enable = true, -- Show git status icons
	},
})

-- Claude code



-- LSP config

local lspconfig = require('lspconfig')

-- Python LSP
lspconfig.pyright.setup {}

-- Rust LSP
lspconfig.rust_analyzer.setup {}

-- Add additional LSP servers here as needed




-- keybindings


local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Indentscope
map('n', '[i', '<cmd>lua MiniIndentscope.goto_prev()<CR>', opts)
map('n', ']i', '<cmd>lua MiniIndentscope.goto_next()<CR>', opts)

-- Jump
map('n', 's', '<cmd>lua MiniJump.jump()<CR>', opts)

-- Files
map('n', '<leader>e', '<cmd>lua MiniFiles.open()<CR>', opts)

-- Comment
map('n', '<leader>/', '<cmd>lua MiniComment.toggle_lines()<CR>', opts)
map('v', '<leader>/', '<cmd>lua MiniComment.toggle_lines()<CR>', opts)


-- Navigate buffers
map('n', '<Tab>', ':BufferLineCycleNext<CR>', opts)
map('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', opts)

-- Close current buffer
map('n', '<leader>bd', ':bdelete<CR>', opts)

-- Find buffer by name

vim.api.nvim_set_keymap(
	'n', '<leader>bb', -- Triggered by <leader>bb
	':Telescope buffers<CR>', -- Opens Telescope buffer picker
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	'n', '<C-p>',
	':Telescope find_files<CR>', -- Opens Telescope file picker
	{ noremap = true, silent = true }
)

-- Find file by name
vim.api.nvim_set_keymap(
	'n', '<leader>ff',    -- Trigger with <leader>ff
	':Telescope find_files<CR>', -- Opens file finder
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	'n', '<leader>fs', -- Trigger with <leader>fs
	':lua require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })<CR>',
	{ noremap = true, silent = true }
)

-- Find content in file
vim.api.nvim_set_keymap(
	'n', '<leader>fg', -- Trigger with <leader>fg
	':Telescope live_grep<CR>',
	{ noremap = true, silent = true }
)

-- Find selected text in file
vim.api.nvim_set_keymap(
	'v', '<leader>fg',
	[[:<C-u>lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cword>') })<CR>]],
	{ noremap = true, silent = true }
)

-- Move selected block up
vim.api.nvim_set_keymap(
	'x', '<C-k>',
	":move '<-2<CR>gv-gv",
	{ noremap = true, silent = true }
)

-- Move selected block down
vim.api.nvim_set_keymap(
	'x', '<C-j>',
	":move '>+1<CR>gv-gv",
	{ noremap = true, silent = true }
)



-- Helper function for setting up LSP keybindings
local on_attach = function(client, bufnr)
	-- Helper function for setting up buffer-local keymaps
	local buf_set_keymap = function(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local opts = { noremap = true, silent = true }

	-- Go to declaration
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	-- Go to definition
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	-- Show references
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	-- Rename symbol
	buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	-- Show hover information
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	-- Show signature help
	buf_set_keymap('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	-- Show diagnostics
	buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	-- Navigate diagnostics
	buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end,
		})
	end
end

vim.api.nvim_set_keymap(
	'n', '<leader>fm',                            -- Keybinding <leader>fm
	'<cmd>lua vim.lsp.buf.format({ async = true })<CR>', -- Format the current buffer
	{ noremap = true, silent = true }
)

-- Keybindings for nvim-tree
vim.api.nvim_set_keymap(
	'n', '<leader>e',
	':NvimTreeToggle<CR>', -- Toggle the file tree
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	'n', '<leader>r',
	':NvimTreeRefresh<CR>', -- Refresh the file tree
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	'n', '<leader>n',
	':NvimTreeFindFile<CR>', -- Find the current file in the tree
	{ noremap = true, silent = true }
)



-- Update LSP server configurations to use the on_attach function
lspconfig.pyright.setup { on_attach = on_attach }
lspconfig.rust_analyzer.setup { on_attach = on_attach }


local lspconfig = require('lspconfig')

-- Set up Lua LSP
lspconfig.lua_ls.setup {
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT', -- Neovim uses LuaJIT
				path = vim.split(package.path, ';'),
			},
			diagnostics = {
				globals = { 'vim' }, -- Recognize `vim` as a global variable
			},
			workspace = {
				library = {
					[vim.fn.expand('$VIMRUNTIME/lua')] = true, -- Neovim runtime files
					[vim.fn.stdpath('config') .. '/lua'] = true, -- Your config files
				},
				checkThirdParty = false, -- Disable unnecessary prompts
			},
			telemetry = {
				enable = false, -- Disable telemetry for privacy
			},
		},
	},
}

local lspconfig = require('lspconfig')

-- Set up Go LSP (gopls)
lspconfig.gopls.setup {
	on_attach = on_attach,                                  -- Use the same on_attach function for keybindings
	capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Optional: LSP completion support
	settings = {
		gopls = {
			analyses = {
				unusedparams = true, -- Enable unused parameter analysis
				nilness = true, -- Detect nil-related issues
			},
			staticcheck = true, -- Enable additional static checks
		},
	},
}


local lspconfig = require('lspconfig')

-- Set up C++ LSP (clangd)
lspconfig.clangd.setup {
	on_attach = on_attach,                                  -- Use your existing on_attach function
	capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Use nvim-cmp for autocompletion
	cmd = { "clangd", "--background-index", "--clang-tidy" }, -- Additional options for clangd
	filetypes = { "c", "cpp", "objc", "objcpp" },           -- Supported filetypes
	settings = {
		clangd = {
			fallbackFlags = { "-std=c++20" }, -- Set default compilation flags
		},
	},
}

require("claude-code").setup({
	-- Terminal window settings
	window = {
		split_ratio = 0.3, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
		position = "botright", -- Position of the window: "botright", "topleft", "vertical", "float", etc.
		enter_insert = true, -- Whether to enter insert mode when opening Claude Code
		hide_numbers = true, -- Hide line numbers in the terminal window
		hide_signcolumn = true, -- Hide the sign column in the terminal window

		-- Floating window configuration (only applies when position = "float")
		float = {
			width = "80%", -- Width: number of columns or percentage string
			height = "80%", -- Height: number of rows or percentage string
			row = "center", -- Row position: number, "center", or percentage string
			col = "center", -- Column position: number, "center", or percentage string
			relative = "editor", -- Relative to: "editor" or "cursor"
			border = "rounded", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
		},
	},
	-- File refresh settings
	refresh = {
		enable = true, -- Enable file change detection
		updatetime = 100, -- updatetime when Claude Code is active (milliseconds)
		timer_interval = 1000, -- How often to check for file changes (milliseconds)
		show_notifications = true, -- Show notification when files are reloaded
	},
	-- Git project settings
	git = {
		use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
	},
	-- Shell-specific settings
	shell = {
		separator = '&&', -- Command separator used in shell commands
		pushd_cmd = 'pushd', -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
		popd_cmd = 'popd', -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
	},
	-- Command settings
	command = "claude", -- Command used to launch Claude Code
	-- Command variants
	command_variants = {
		-- Conversation management
		continue = "--continue", -- Resume the most recent conversation
		resume = "--resume", -- Display an interactive conversation picker

		-- Output options
		verbose = "--verbose", -- Enable verbose logging with full turn-by-turn output
	},
	-- Keymaps
	keymaps = {
		toggle = {
			normal = "<C-,>", -- Normal mode keymap for toggling Claude Code, false to disable
			terminal = "<C-,>", -- Terminal mode keymap for toggling Claude Code, false to disable
			variants = {
				continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
				verbose = "<leader>cV", -- Normal mode keymap for Claude Code with verbose flag
			},
		},
		window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
		scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
	}
})



-- Custom commands

-- Custom command to copy the absolute file path of the current buffer
vim.api.nvim_create_user_command(
	'CopyFilePath',
	function()
		local filepath = vim.fn.expand('%:p') -- Get the absolute file path
		vim.fn.setreg('+', filepath) -- Copy to system clipboard
		print('Copied file path to clipboard: ' .. filepath)
	end,
	{}
)

-- Custom command to copy the relative file path of the current buffer
vim.api.nvim_create_user_command(
	'CopyRelativeFilePath',
	function()
		local filepath = vim.fn.expand('%') -- Get the relative file path
		vim.fn.setreg('+', filepath) -- Copy to system clipboard
		print('Copied relative file path to clipboard: ' .. filepath)
	end,
	{}
)


-- Custom command to create or edit a file in the current buffer's directory
vim.api.nvim_create_user_command(
	'EditFileInDir',
	function(args)
		-- Get the directory of the current buffer's file
		local dir = vim.fn.expand('%:p:h') -- %:p:h expands to the directory of the current file
		local filepath = dir .. '/' .. args.args -- Combine the directory with the provided filename

		-- Open the file in the current buffer
		vim.cmd('edit ' .. filepath)
		print('Editing file: ' .. filepath)
	end,
	{ nargs = 1, complete = 'file' } -- Require a filename argument and provide file completion
)
