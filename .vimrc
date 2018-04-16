" ###########
" # General #
" ###########

" # Settings #

" Use latest Vim settings/options (as opposed to being compatible with Vi).
set nocompatible
" Syntax highlighting.
syntax on 
" Line number.
set nu 
" Make backspace sane again!
set backspace=indent,eol,start 
" Set leader as comma since default leader of backshash isn't very convenient.
let mapleader = ','

" - Indentation -
" Number of columns text is indented with the reindent operations (<< and >>) and automatic C-style indentation.
set shiftwidth=2
" Number of columns to text is indented by.
set softtabstop=2 
" Hitting Tab in insert mode will produce the appropriate number of spaces.
set expandtab
" How many columns a tab counts for.
set tabstop=2

" - Statusbar -
" Status line.
set laststatus=2
" Show row and column for cursor.
set ruler

" - Search -
" Highlight search results.
set hlsearch
" Incremental search.
set incsearch 
" Case insensitive search.
set ignorecase

" - Splits -
" Open new split below and right, when creating new horizontal and vertical splits respectively.
set splitbelow
set splitright

" - Visual -
colorscheme Tomorrow 
" Force 256 colors in terminal Vim.
set t_CO=256
" Color scheme: seoul256 (dark):
" Range:   233 (darkest) ~ 239 (lightest)
" Default: 237
let g:seoul256_background = 235

" # Functions #

function! s:colors(...)
  return filter(map(filter(split(globpath(&rtp, 'colors/*.vim'), "\n"),
        \                  'v:val !~ "^/usr/"'),
        \           'fnamemodify(v:val, ":t:r")'),
        \       '!a:0 || stridx(v:val, a:1) >= 0')
endfunction

function! s:rotate_colors(rev)
  if !exists('s:colors')
    let s:colors = s:colors()
  endif
  let name = remove(s:colors, a:rev == 'true' ? -1 : 0)
  if a:rev == 'true'
    call insert(s:colors, name, 0)
  else
    call add(s:colors, name)
  endif
  execute 'colorscheme' name
  redraw
  echo 'Colour scheme:' name
endfunction

" # Mappings #

" Make it easy to quickly edit .vimrc file.
nmap <Leader>ev :tabedit $MYVIMRC<cr> " i.e. type ,ev to open .vimrc file in a new tab.
" Un-highlight search results.
nmap <Leader><space> :nohlsearch<cr>
nnoremap <silent> <F8> :call <SID>rotate_colors('false')<cr>
nnoremap <silent> <S-F8> :call <SID>rotate_colors('true')<cr>

" - Splits -
" Omit <ctrl>+w when switching to splits based on directions.
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>

" # Auto-commands #

" Make sure auto command for sourcing .vimrc doesn't get duplicated everytime
" it's sourced. Otherwise, Vim slows down to almost a halt.
augroup MyAutoSourcing
  " Clear existing auto group.
  autocmd! 
  " Source .vimrc file upon save.
  autocmd BufWritePost .vimrc source % " i.e. when .vimrc file is written to, source it.
  " Have netrw open when Vim starts.
  " autocmd VimEnter * :Vexplore  
augroup END

" ############
" # Plug-ins #
" ############

" -------
" - FZF -
" -------

" # Settings #

" Default fzf layout - down / up / left / right
let g:fzf_layout = { 'right': '~35%' }
" [Tags] Command to generate tags file.
let g:fzf_tags_command = 'ag -l | ctags -L-'

" # Mappings #

" FZF buffer tags.
nmap <Leader>bt :BTags<cr>
" FZF tags.
nmap <Leader>t :Tags<cr>
" FZF files.
nmap <Leader>f :Files<cr>
" FZF buffers.
nmap <Leader>bf :Buffers<cr>
nmap <D-e> :Buffers<cr>

" # Commands #

" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Show preview of files for FZF's 'Files' command.
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('down:50%'), <bang>0)

" ------------
" - NERDTree -
" ------------

" # Settings #

" Let ^6 return from NERDTree window.
let g:NERDTreeCreatePrefix='silent keepalt keepjumps'

function! s:attempt_select_last_file()
  let l:previous=expand('#:t')
  if l:previous != ''
    call search('\v<' . l:previous . '>')
  endif
endfunction

" # Mappings #

" Make it easier to toggle NERDTree.
nmap <Leader>1 :NERDTreeToggle<cr>
" Vinegar-like up operation in NERDTree, while in a buffer.
nmap <buffer> <expr> - g:NERDTreeMapUpdir
" Show NERDTree in a buffer, in a Vinegar-like fashion. This mapping will run
" the 'edit' command on the current directory, which will essentially open
" NERDTree. '<C-R>=' simply computes an expression and returns the result. 
nnoremap <silent> - :silent edit <C-R>=empty(expand('%')) ? '.' : expand('%:p:h')<CR><CR>

" # Auto-commands #

augroup MyNERDTree
  autocmd!
  " Have NERDTree open when Vim starts.
  autocmd VimEnter * :NERDTreeToggle  
  " Attempt to select current file in NERDTree.
  autocmd User NERDTreeInit call s:attempt_select_last_file()
augroup END

" ---------
" - Netrw -
" ---------

" # Settings #

" Set default netrw view to tree mode (currently disabled as it seems to have a weird
" bug which causes pain when trying to quite Vim).
" let g:netrw_liststyle = 3
" Remove top banner from netrw.
let g:netrw_banner = 0
" Specify how files are opened from netrw.
let g:netrw_browse_split = 4 " 1: horizontal split, 2: vertical split, 3: new tab, 4: previous window.
" Width of netrw explorer (use without '-' for percentage of screen width).
let g:netrw_winsize = -30
let g:netrw_altv=1

" ------------
" - Vim-Plug -
" ------------

" Specify a directory for plugins.
call plug#begin('~/.vim/plugged')
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Yggdroot/indentLine'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Colors
Plug 'gosukiwi/vim-atom-dark'
Plug 'tomasr/molokai'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'morhetz/gruvbox'
Plug 'yuttie/hydrangea-vim'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'AlessandroYorba/Despacio'
Plug 'cocopon/iceberg.vim'
Plug 'w0ng/vim-hybrid'
Plug 'junegunn/seoul256.vim'

" Initialize plugin system.
call plug#end()

" #######
" # EOF #
" #######
