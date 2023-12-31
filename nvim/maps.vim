" Description: Keymaps

let mapleader = ","
let g:mapleader = ","

" Leader key timeout
set tm=2000

" Fast saving - just press ,w
nmap <leader>w :w!<cr>

set lsp=2

nnoremap <S-C-p> "0p

" peekup
let g:peekup_open = '<leader>"'
let g:peekup_paste_before = '<leader>P'
let g:peekup_paste_after = '<leader>p'

" Delete without yank
nnoremap <leader>d "_d
nnoremap x "_x

" Increment/decrement
nnoremap + <C-a>
nnoremap - <C-x>

" Delete a word backwards
nnoremap dw vb"_d

" Select all
nmap <C-a> gg<S-v>G

" Save with root permission
command! W w !sudo tee > /dev/null %

nmap <leader>d :Goyo<CR>

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

"-----------------------------
" Tabs

" Open current directory
nmap te :tabedit 
nmap <S-Tab> :tabprev<Return>
nmap <Tab> :tabnext<Return>

""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" => Moving around, tabs, windows and buffers

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

nnoremap <space> :Bufstop<CR>

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

nnoremap <C-W>/ :vsplit<cr>

tnoremap <Esc> <C-\><C-n>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :bclose<cr>

" bbye
nnoremap <Leader>q :Bdelete<CR>

command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>

cmap <C-P> <Up>
cmap <C-N> <Down>

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
map <leader>e :tabedit <c-r>=expand("%:p:h")<cr>/
" Opens a new buffer with the current buffer's path
map <leader>f :edit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

nnoremap <leader>bb :Bufstop<cr>
nnoremap <leader>bk :bnext<cr>
nnoremap <leader>bl :bprevious<cr>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Start new vim instance
nnoremap <leader>0 :!nvim-qt<cr><cr>

"------------------------------
" Windows

" Split window
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w
" Move window
nmap <Space> <C-w>w
map s<left> <C-w>h
map s<up> <C-w>k
map s<down> <C-w>j
map s<right> <C-w>l
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l

" Resize window
nmap <C-w><left> <C-w><
nmap <C-w><right> <C-w>>
nmap <C-w><up> <C-w>+
nmap <C-w><down> <C-w>-

" Visual mode pressing * or # searches for the current selection {{{
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" => Moving around, tabs, windows and buffers

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

nnoremap <C-W>/ :vsplit<cr>

tnoremap <Esc> <C-\><C-n>

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

cmap <C-P> <Up>
cmap <C-N> <Down>

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

nnoremap <leader>bb :Bufstop<cr>
nnoremap <leader>bk :bnext<cr>
nnoremap <leader>bl :bprevious<cr>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Start new vim instance
nnoremap <leader>0 :!nvim-qt<cr><cr>

" Python formatting
nnoremap <buffer><silent> <c-q> <cmd>call Black()<cr>
inoremap <buffer><silent> <c-q> <cmd>call Black()<cr>

" fzf

" This is the default option:
"   - Preview window on the right with 50% width
"   - CTRL-/ will toggle preview window.
" - Note that this array is passed as arguments to fzf#vim#with_preview function.
" - To learn more about preview window options, see `--preview-window` section of `man fzf`.
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Preview window on the upper side of the window with 40% height,
" hidden by default, ctrl-/ to toggle
let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']

" Empty value to disable preview window altogether
let g:fzf_preview_window = []

nnoremap <silent> <C-t> :FZF -m<cr>
nnoremap <silent> <C-p> :FZF -m<cr>
nnoremap <silent> <C-k> :Buffers<cr>
nnoremap <silent> <C-S-k> :History<cr>

augroup ScrollbarInit
  autocmd!
  autocmd CursorMoved,VimResized,QuitPre * silent! lua require('scrollbar').show()
  autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
  autocmd WinLeave,BufLeave,BufWinLeave,FocusLost            * silent! lua require('scrollbar').clear()
augroup end

" symbols-outline
nnoremap <silent> <C-s> :SymbolsOutline<cr>

" Move to previous/next
nnoremap <silent>    <D-,> :BufferPrevious<CR>
nnoremap <silent>    <D-.> :BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <D-<> :BufferMovePrevious<CR>
nnoremap <silent>    <D->> :BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>    <D-1> :BufferGoto 1<CR>
nnoremap <silent>    <D-2> :BufferGoto 2<CR>
nnoremap <silent>    <D-3> :BufferGoto 3<CR>
nnoremap <silent>    <D-4> :BufferGoto 4<CR>
nnoremap <silent>    <D-5> :BufferGoto 5<CR>
nnoremap <silent>    <D-6> :BufferGoto 6<CR>
nnoremap <silent>    <D-7> :BufferGoto 7<CR>
nnoremap <silent>    <D-8> :BufferGoto 8<CR>
nnoremap <silent>    <D-9> :BufferLast<CR>
" Pin/unpin buffer
nnoremap <silent>    <D-p> :BufferPin<CR>
" Close buffer
nnoremap <silent>    <D-c> :BufferClose<CR>
" Wipeout buffer
"                          :BufferWipeout<CR>
" Close commands
nnoremap <silent> <D-d>    :BufferCloseAllButCurrent<CR>
"                          :BufferCloseAllButPinned<CR>
"                          :BufferCloseBuffersLeft<CR>
"                          :BufferCloseBuffersRight<CR>
" Magic buffer-picking mode
nnoremap <silent> <C-o>    :BufferPick<CR>
" Sort automatically by...
nnoremap <silent> <Space>bd :BufferOrderByDirectory<CR>
nnoremap <silent> <Space>bl :BufferOrderByLanguage<CR>
nnoremap <silent> <Space>bw :BufferOrderByWindowNumber<CR>

" Float
nnoremap   <silent>   <F7>    :FloatermNew<CR>
tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <F8>    :FloatermPrev<CR>
tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <silent>   <F9>    :FloatermNext<CR>
tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
nnoremap   <silent>   <F12>   :FloatermToggle<CR>
tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>

" Other:
" :BarbarEnable - enables barbar (enabled by default)
" :BarbarDisable - very bad command, should never be used

nnoremap <leader>S :lua require('spectre').open()<CR>

"search current word
nnoremap <leader>sw :lua require('spectre').open_visual({select_word=true})<CR>
vnoremap <leader>s :lua require('spectre').open_visual()<CR>
"  search in current file
nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>
