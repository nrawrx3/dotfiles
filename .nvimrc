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
set number
set norelativenumber

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file, and the leader is ,
let mapleader = ","
let g:mapleader = ","

" Leader key timeout
set tm=2000

" Fast saving - just press ,w
nmap <leader>w :w!<cr>

set lsp=2

" Window dimensions
set lines=40 columns=120

" Use par for prettier line formatting
set formatprg="PARINIT='rTbgqR B=.,?_A_a Q=_s>|' par\ -w72"

" Normal use of ",", press twice
noremap ,, ,

" Kill the damned Ex mode(?)
nnoremap Q <nop>

" colorscheme names that we use to set color
let s:mycolors = ['vividchalk', 'wombat256mod', 'plumber-dark']

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

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-vinegar'
Plug 'vim-scripts/Align'
Plug 'vim-scripts/Gundo'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'
Plug 'michaeljsmith/vim-indent-object'
Plug 'guns/vim-sexp'
Plug 'kien/rainbow_parentheses.vim'
Plug 'rhysd/nyaovim-markdown-preview'
Plug 'scrooloose/nerdcommenter'
Plug 'Shougo/denite.nvim'
Plug 'tpope/vim-surround'
Plug 'haya14busa/incsearch.vim'

Plug 'hdima/python-syntax'
Plug 'plasticboy/vim-markdown'
Plug 'fatih/vim-go', { 'for': ['go'] }
Plug 'tpope/vim-fireplace'
Plug 'venantius/vim-cljfmt'
Plug 'tikhomirov/vim-glsl'
Plug 'editorconfig/editorconfig-vim'
Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp', 'python', 'rust'] }
autocmd! User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif
Plug 'ternjs/tern_for_vim'
Plug 'maksimr/vim-jsbeautify'
Plug 'rhysd/vim-clang-format'
Plug 'mindriot101/vim-yapf'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'Superbil/llvm.vim'
Plug 'elixir-editors/vim-elixir'
Plug 'slashmili/alchemist.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'romainl/Apprentice'
Plug 'tpope/vim-vividchalk'
Plug 'lifepillar/vim-solarized8'
Plug 'abnt713/vim-hashpunk'

call plug#end()
"filetype plugin indent on

colorscheme paramount

" PLUGINS DONE

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10split enew' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

nnoremap <c-p> :FZF<cr>

augroup fzf
  autocmd!
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

nnoremap <silent> <Leader><space> :FZF<CR>

" => Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='biogoo'

" => YouCompleteMe


" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0

" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = exepath("clangd")

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
" Nope. Don't want to see tabs.
if &listchars ==# 'eol:$'
    set listchars=tab:\`\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

set listchars=tab:\ \ 


" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

"nnoremap <C-N> :bnext<CR>
"nnoremap <C-P> :bprev<CR>

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

map <C-a> <esc>ggVG<CR>

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

autocmd FileType c setlocal et ts=4 sw=4 sts=4 textwidth=110
autocmd filetype python setlocal et ts=4 sw=4 sts=4 textwidth=1000
autocmd filetype elixir setlocal et ts=2 sw=2 sts=2 textwidth=100
autocmd FileType cpp setlocal et ts=4 sw=4 sts=4 textwidth=110
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

set colorcolumn=110
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

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

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

nnoremap <leader>bk :bnext<cr>
nnoremap <leader>bl :bprevious<cr>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%


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

map <C-U> <C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>
map <C-D> <C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>


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


" Change the color scheme from a list of color scheme names.
" Version 2010-09-12 from http://vim.wikia.com/wiki/VimTip341
" Press key:
"   F8                next scheme
"   Shift-F8          previous scheme
"   Alt-F8            random scheme
" Set the list of color schemes used by the above (default is 'all'):
"   :SetColors all              (all $VIMRUNTIME/colors/*.vim)
"   :SetColors my               (names built into script)
"   :SetColors blue slate ron   (these schemes)
"   :SetColors                  (display current scheme names)
" Set the current color scheme based on time of day:
"   :SetColors now
if v:version < 700 || exists('loaded_setcolors') || &cp
  finish
endif

let loaded_setcolors = 1

" Set list of color scheme names that we will use, except
" argument 'now' actually changes the current color scheme.
function! s:SetColors(args)
  if len(a:args) == 0
    echo 'Current color scheme names:'
    let i = 0
    while i < len(s:mycolors)
      echo '  '.join(map(s:mycolors[i : i+4], 'printf("%-14s", v:val)'))
      let i += 5
    endwhile
  elseif a:args == 'all'
    let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
    let s:mycolors = map(paths, 'fnamemodify(v:val, ":t:r")')
    echo 'List of colors set from all installed color schemes'
  elseif a:args == 'my'
    let c1 = 'default elflord peachpuff desert256 breeze morning'
    let c2 = 'darkblue gothic aqua earth black_angus relaxedgreen'
    let c3 = 'darkblack freya motus impact less chocolateliquor'
    let s:mycolors = split(c1.' '.c2.' '.c3)
    echo 'List of colors set from built-in names'
  elseif a:args == 'now'
    call s:HourColor()
  else
    let s:mycolors = split(a:args)
    echo 'List of colors set from argument (space-separated names)'
  endif
endfunction

command! -nargs=* SetColors call s:SetColors('<args>')

" Set next/previous/random (how = 1/-1/0) color from our list of colors.
" The 'random' index is actually set from the current time in seconds.
" Global (no 's:') so can easily call from command line.
function! NextColor(how)
  call s:NextColor(a:how, 1)
endfunction

" Helper function for NextColor(), allows echoing of the color name to be
" disabled.
function! s:NextColor(how, echo_color)
  if len(s:mycolors) == 0
    call s:SetColors('all')
  endif
  if exists('g:colors_name')
    let current = index(s:mycolors, g:colors_name)
  else
    let current = -1
  endif
  let missing = []
  let how = a:how
  for i in range(len(s:mycolors))
    if how == 0
      let current = localtime() % len(s:mycolors)
      let how = 1  " in case random color does not exist
    else
      let current += how
      if !(0 <= current && current < len(s:mycolors))
        let current = (how>0 ? 0 : len(s:mycolors)-1)
      endif
    endif
    try
      execute 'colorscheme '.s:mycolors[current]
      break
    catch /E185:/
      call add(missing, s:mycolors[current])
    endtry
  endfor
  redraw
  if len(missing) > 0
    echo 'Error: colorscheme not found:' join(missing)
  endif
  if (a:echo_color)
    echo g:colors_name
  endif
endfunction

nnoremap <F8> :call NextColor(1)<CR>
nnoremap <S-F8> :call NextColor(-1)<CR>
nnoremap <A-F8> :call NextColor(0)<CR>

function DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction

