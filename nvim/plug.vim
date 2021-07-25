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
  " Plug 'glepnir/dashboard-nvim'
  Plug 'gennaro-tedesco/nvim-peekup'
  Plug 'karb94/neoscroll.nvim'
  Plug 'Xuyuanp/scrollbar.nvim'
  " Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'a-vrma/black-nvim', {'do': ':UpdateRemotePlugins'}
  Plug 'kevinhwang91/rnvimr'
  " Plug 'jbyuki/venn.nvim'
  Plug 'junegunn/limelight.vim'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-commentary'

  " Language specific
  Plug 'ray-x/go.nvim'

  " Colorscheme
  " Plug 'arcticicestudio/nord-vim'
  Plug 'shaunsingh/nord.nvim'
  Plug 'olivertaylor/vacme'
  Plug 'duckwork/nirvana'
  Plug 'folke/tokyonight.nvim'
  Plug 'glepnir/zephyr-nvim'
  Plug 'kyazdani42/blue-moon'
  Plug 'sainnhe/everforest'
  Plug 'novakne/kosmikoa.nvim'
  Plug 'shaunsingh/moonlight.nvim'
  Plug 'sainnhe/gruvbox-material'
endif

Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

call plug#end()
