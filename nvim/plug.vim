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
  Plug 'simrat39/symbols-outline.nvim'
  Plug 'nvim-lua/completion-nvim'
  Plug 'lukas-reineke/format.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  " Plug 'glepnir/dashboard-nvim'
  Plug 'mhinz/vim-startify'
  Plug 'gennaro-tedesco/nvim-peekup'
  " Plug 'karb94/neoscroll.nvim'
  Plug 'Xuyuanp/scrollbar.nvim'
  " Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'a-vrma/black-nvim', {'do': ':UpdateRemotePlugins'}
  Plug 'kevinhwang91/rnvimr'
  " Plug 'jbyuki/venn.nvim'
  Plug 'junegunn/limelight.vim'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'folke/twilight.nvim' 
  Plug 'tpope/vim-commentary'
  Plug 'xiyaowong/nvim-cursorword'
  Plug 'Pocco81/HighStr.nvim'
  " Plug 'rmagatti/auto-session'
  Plug 'edluffy/specs.nvim'
  Plug 'abecodes/tabout.nvim'
  Plug 'voldikss/vim-floaterm'
  Plug 'romgrk/barbar.nvim'
  " Plug 'ahmedkhalf/project.nvim'
  "Plug 'nvim-lua/plenary.nvim'
  Plug 'windwp/nvim-spectre'
  Plug 'f-person/git-blame.nvim'

  " Language specific
  Plug 'ray-x/go.nvim'

  " Colorscheme
  " Plug 'arcticicestudio/nord-vim'
  Plug 'shaunsingh/nord.nvim'
  Plug 'olivertaylor/vacme'
  Plug 'duckwork/nirvana'
  Plug 'folke/tokyonight.nvim'
  Plug 'rose-pine/neovim'
  Plug 'arzg/vim-substrata'
  Plug 'Th3Whit3Wolf/space-nvim'
  Plug 'ishan9299/nvim-solarized-lua'
  Plug 'sainnhe/everforest'
  Plug 'ishan9299/modus-theme-vim'
  Plug 'https://git.sr.ht/~novakane/argi.nvim'
  Plug 'sainnhe/gruvbox-material'
  Plug 'nxvu699134/vn-night.nvim'
  Plug 'kdheepak/monochrome.nvim'
  Plug 'fenetikm/falcon'
endif

Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

call plug#end()
