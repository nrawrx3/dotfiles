" ~/.config/nvim/init.vim or ~/.vimrc

" => General


" Sets how many lines of history VIM has to remember
set history=700

" use indentation for folds
set foldmethod=indent
set foldnestmax=5
set foldlevelstart=99
set foldcolumn=0

" Enable filetype plugins - important for vundle and some languages
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Line numbers
"set relativenumber
"set number

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file, and the leader is ,
let mapleader = ","
let g:mapleader = ","

" Leader key timeout
set tm=2000

" Fast saving - just press ,w
nmap <leader>w :w!<cr>

" Window dimensions
set lines=40 columns=100

" Use par for prettier line formatting
set formatprg="PARINIT='rTbgqR B=.,?_A_a Q=_s>|' par\ -w72"

" Normal use of ",", press twice
noremap ,, ,

" Kill the damned Ex mode(?)
nnoremap Q <nop>

" PLUGINS

call plug#begin('~/.config/nvim/plugged')

Plug 'gmarik/Vundle.vim'
Plug 'Shougo/vimproc.vim'
Plug 'ervandew/supertab'
Plug 'moll/vim-bbye'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'vim-scripts/gitignore'
Plug 'tpope/vim-fugitive'
Plug 'int3/vim-extradite'

Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-vinegar'
Plug 'vim-scripts/Align'
Plug 'vim-scripts/Gundo'
Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'
Plug 'michaeljsmith/vim-indent-object'
Plug 'guns/vim-sexp'
Plug 'kien/rainbow_parentheses.vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'rhysd/nyaovim-markdown-preview'



Plug 'hdima/python-syntax'
Plug 'plasticboy/vim-markdown'
Plug 'fatih/vim-go', { 'for': ['go'] }
Plug 'tpope/vim-fireplace'
Plug 'cespare/vim-toml'
Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp', 'python', 'rust', 'nim'] }
autocmd! User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif
Plug 'ternjs/tern_for_vim'
Plug 'maksimr/vim-jsbeautify'
Plug 'rhysd/vim-clang-format'
Plug 'mindriot101/vim-yapf'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'Superbil/llvm.vim'
Plug 'romainl/Apprentice'
Plug 'bluz71/vim-moonfly-colors'

call plug#end()
"filetype plugin indent on

" PLUGINS DONE

" => Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='zenburn'

" => YouCompleteMe


let g:ycm_global_ycm_extra_conf = "~/.config/nvim/ycm_extra_conf.py"
let g:ycm_confirm_extra_conf = 1
" Use <tab> for ultipsnips and use <C-n> and <C-p> for ycm
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
"let g:ycm_autoclose_preview_window_after_completion=1

let g:ycm_rust_src_path="/usr/src/rust/src/"

let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
let g:ycm_semantic_triggers = {'haskell' : ['.'], 'rust': ['.', '::']}

let python_highlight_all = 1

" => Syntastic Checking (not using)

"map <silent> <Leader>e :Errors<CR>
"map <Leader>s :SyntasticToggleMode<CR>

"let g:syntastic_auto_loc_list=1

"let g:syntastic_cpp_compiler = 'clang++'
"let g:syntastic_cpp_compiler_options = '-std=c++14'


" => Vim Cpp Enhanced

let g:cpp_class_scope_highlight = 1

let g:cpp_experimental_template_highlight = 1


" => VIM user interface

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Tab-complete files up to longest unambiguous prefix
set wildmode=list:longest,full

" Show trailing whitespace
set list
" But only interesting whitespace
if &listchars ==# 'eol:$'
  set listchars=tab:\`\ ,trail:-,extends:>,precedes:<,nbsp:+
endif


" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set vb t_vb=
set tm=500

if &term =~ '256color'
"  " disable Background Color Erase (BCE) so that color schemes
"  " render properly when inside 256-color tmux and GNU screen.
"  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Force redraw
map <silent> <leader>r :redraw!<CR>

" Turn mouse mode on
nnoremap <leader>ma :set mouse=a<cr>

" Turn mouse mode off
nnoremap <leader>mo :set mouse=<cr>

" Default to mouse mode on
set mouse=a



" => Colors and Fonts


" Enable syntax highlighting
syntax on

map <silent> <F5> :call gruvbox#bg_toggle()<CR>
imap <silent> <F5> <ESC>:call gruvbox#bg_toggle()<CR>a
vmap <silent> <F5> <ESC>:call gruvbox#bg_toggle()<CR>gv

colorscheme moonfly

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set guioptions-=m
    set guioptions-=r
    set t_Co=256
    set guitablabel=%M\ %t
endif

"hi Cursor guifg=red

hi Cursor ctermfg=red
" Adjust signscolumn and syntastic to match wombat
hi! link SignColumn LineNr
hi! link SyntasticErrorSign ErrorMsg
hi! link SyntasticWarningSign WarningMsg


" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

set guifont=IosevkaTermHeavy\ 10

" => Files, backups and undo

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Source the vimrc file after saving it
augroup sourcing
  autocmd!
  autocmd bufwritepost .vimrc source $MYVIMRC
augroup END

" Open file prompt with current path
nmap <leader>e :e <C-R>=expand("%:p:h") . '/'<CR>

" Show undo tree
nmap <silent> <leader>u :GundoToggle<CR>

" Fuzzy find files
nnoremap <silent> <Leader><space> :CtrlP<CR>
let g:ctrlp_max_files=0
let g:ctrlp_show_hidden=1
let g:ctrlp_custom_ignore = { 'dir': '\v[\/](.git)$' }




" => Default indentation and tab widths

" Tabs should be tabs by default, not spaces
set noexpandtab
" Be smart when using tabs ;)
set smarttab
set textwidth=100
set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent

" File type specific tab options

autocmd FileType c setlocal et ts=4 sw=4 sts=4
autocmd FileType python setlocal et ts=4 sw=4 sts=4 textwidth=1000
autocmd FileType cpp setlocal et ts=4 sw=4 sts=4
autocmd FileType vim setlocal et ts=4 sw=4 sts=4
autocmd FileType scheme setlocal et ts=2 sw=2 sts=2
autocmd FileType bash setlocal et ts=4 sw=4 sts=4
autocmd FileType zsh setlocal et ts=4 sw=4 sts=4
autocmd FileType go setlocal noet ts=4 sw=4 sts=4
autocmd FileType d setlocal et ts=4 sw=4 sts=4
autocmd FileType lemon set noet ts=4 sw=4 sts=4
au BufRead,BufNewFile *.rs set filetype=rust
au BufRead,BufNewFile *.toml set filetype=toml
" Linebreak on 80 characters
set lbr
set tw=80

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

""set exrc
""set secure

set colorcolumn=100
highlight ColorColumn ctermbg=white guibg=white


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>



" => Moving around, tabs, windows and buffers

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" bbye
nnoremap <Leader>q :Bdelete<CR>

command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tk :tabnext<cr>
map <leader>tl :tabprevious<cr>

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

let g:ctrlp_map = '<c-p>'


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l



" => Editing mappings

" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text up or down using ALT+[ui] or Comamnd+[jk] on mac
nmap <M-i> mz:m+<cr>`z
nmap <M-u> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()



" => vimgrep searching and cope displaying (UNUSED)

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>



" => Spell checking

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=



" => Tagbar

" Toggle
nmap <leader>= :TagbarToggle<CR>
let g:tagbar_autofocus = 1



" => Misc

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


" => NERDTree


" Close nerdtree after a file is selected
let NERDTreeQuitOnOpen = 1

function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! ToggleFindNerd()
  if IsNERDTreeOpen()
    exec ':NERDTreeToggle'
  else
    exec ':NERDTreeFind'
  endif
endfunction

" If nerd tree is closed, find current file, if open, close it
nmap <silent> <leader>f <ESC>:call ToggleFindNerd()<CR>
nmap <silent> <C-s> <ESC>:call ToggleFindNerd()<CR>


" => Alignment


" Stop Align plugin from forcing its mappings on us
let g:loaded_AlignMapsPlugin=1
" Align on equal signs
map <Leader>a= :Align =<CR>
" Align on commas
map <Leader>a, :Align ,<CR>
" Align on pipes
map <Leader>a<bar> :Align <bar><CR>
" Prompt for align character
map <leader>ap :Align


" => Helper functions

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" Set tabstop, softtabstop and shiftwidth to the same value -- Drew Neill
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

command! Tabinfo call SummarizeTabs()
function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

