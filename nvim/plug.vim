if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'cohama/lexima.vim'

if has("nvim")
  Plug 'hoob3rt/lualine.nvim'
  Plug 'kristijanhusak/defx-git'
  Plug 'mihaifm/bufstop'
  Plug 'haya14busa/incsearch.vim'
  Plug 'kristijanhusak/defx-icons'
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neovim/nvim-lspconfig'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'folke/lsp-colors.nvim'
  Plug 'nvim-lua/completion-nvim'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'


  " Colorscheme
  Plug 'arcticicestudio/nord-vim'
  Plug 'jnurmine/Zenburn'
  Plug 'romainl/Apprentice'
  Plug 'tpope/vim-vividchalk'
  Plug 'lifepillar/vim-solarized8'
  Plug 'morhetz/gruvbox'
  Plug 'arzg/vim-colors-xcode'
  Plug 'jaredgorski/fogbell.vim'
  Plug 'olivertaylor/vacme'
  Plug 'duckwork/nirvana'
endif

Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

call plug#end()
