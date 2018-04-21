" ########
" # Init #
" ########

" Specify a directory for plugins.
call plug#begin('~/.vim/plugged')

" -----------
" - Plugins -
" -----------

Plug 'bfontaine/Brewfile.vim'             " Syntax highlighting for Brewfile.
Plug 'lilydjwg/colorizer'                 " Colourise CSS colours.
Plug 'mattn/emmet-vim'                    " HTML expansion.
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'                   " Vim wrapper for FZF
Plug 'Yggdroot/indentLine'                " Indentation guides.
Plug 'junegunn/goyo.vim'                  " Distraction free writing!
Plug 'skwp/greplace.vim'                  " Search and replace on steroids.
Plug 'junegunn/gv.vim'                    " Git commit browser (uses Fugitive).
Plug 'junegunn/limelight.vim'             " Keep a block in focus, dim everything else.
Plug 'scrooloose/nerdtree',               " File tree.
  \{ 'on':  'NERDTreeToggle' }        
Plug 'majutsushi/tagbar'                  " Intelligently placed tags (symbols) in a sidebar.
Plug 'mbbill/undotree'                    " Visualise Vim's undo tree.
Plug 'vim-airline/vim-airline'            " A more useful status line.
Plug 'ntpeters/vim-better-whitespace'     " Trip whitespaces.
Plug 'tpope/vim-commentary'               " Smart commenting.
Plug 'tpope/vim-fugitive'                 " Git wrapper.
Plug 'tpope/vim-surround'                 " Helps in wrapping stuff around other stuff.
Plug 'airblade/vim-gitgutter'             " Git status indicators in gutter.
Plug 'jreybert/vimagit'                   " Better Git workflow.
Plug 'sheerun/vim-polyglot'               " Syntax highlighting for a whole plethora of languages.
Plug 'vim-scripts/YankRing.vim'           " Sort of like yank-manager.
" Deoplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  "Plug 'Shougo/deoplete.nvim'
  "Plug 'roxma/nvim-yarp'
  "Plug 'roxma/vim-hug-neovim-rpc'
endif

" -----------
" - Colours -
" -----------

" # Light #

Plug 'yuttie/inkstained-vim'
Plug 'soft-aesthetic/soft-era-vim'
Plug 'schickele/vim', { 'as': 'schickele-vim' }
Plug 'wimstefan/vim-artesanal'

" # Dark #

Plug 'vim-scripts/dante.vim'
Plug 'AlessandroYorba/Despacio'
Plug 'yuttie/hydrangea-vim'
Plug 'cocopon/iceberg.vim'
Plug 'tomasr/molokai'
Plug 'gosukiwi/vim-atom-dark'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'ajmwagar/vim-deus'
Plug 'kudabux/vim-srcery-drk'

" # Both #

Plug 'nightsense/carbonized'
Plug 'dracula/vim', { 'as': 'dracula-vim' }
Plug 'nightsense/forgotten'
Plug 'morhetz/gruvbox'
Plug 'yuttie/inkstained-vim'
Plug 'nightsense/nemo'
Plug 'nightsense/plumber'
Plug 'junegunn/seoul256.vim'
Plug 'nightsense/stellarized'
Plug 'nightsense/strawberry'
Plug 'kadekillary/subtle_solo'
Plug 'Renxiuhu/vim-colorscheme'
Plug 'w0ng/vim-hybrid'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'nightsense/wonka'

" Initialize plugin system.
call plug#end()

" ########
" # Core #
" ########

" # Settings #

" Use latest Vim settings/options (as opposed to being compatible with Vi).
set nocompatible
" Allow switching to another file even when current buffer has unsaved changes.
set hidden
" Syntax highlighting.
syntax on
" Hybrid line numbers.
set number relativenumber
" Enable automatic comment continuation (some plug-in seems to have disabled it!).
"set formatoptions=cro
" Make backspace sane again!
set backspace=indent,eol,start
" Set leader as comma since default leader of backshash isn't very convenient.
let mapleader = ','

" - Undo -
set undofile
set undodir=~/.vim/undodir

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
" Set colour scheme based on time of day (superseded by more dynamic stuff below).
"if system('date +%H') < 18
"  execute 'Day' 
"else 
"  execute 'Night'
"endif
" Force 256 colors in terminal Vim.
set t_CO=256
" Color scheme: seoul256 (dark):
" Range:   233 (darkest) ~ 239 (lightest)
" Default: 237
let g:seoul256_background = 235
" Hide vertical split lines.
highlight vertsplit guifg=bg guibg=bg
" Hack to add left padding using fold (not using currently).
"set foldcolumn=1
"highlight foldcolumn guibg=bg
" Make background of linenumbers match window background (not using currently).
"highlight LineNr guibg=bg

" # Variables #
let g:dayTime = [7, 0]
let g:nightTime = [18, 0]

let g:colorschemeDay = 'fruchtig'
let g:colorschemeNight = 'Dracula'

" # Functions #

" Get a list of all colour schemes.
function! s:colours(...)
  return filter(map(filter(split(globpath(&rtp, 'colors/*.vim'), "\n"),
        \                  'v:val !~ "^/usr/"'),
        \           'fnamemodify(v:val, ":t:r")'),
        \       '!a:0 || stridx(v:val, a:1) >= 0')
endfunction

" Rotate colour scheme.
function! s:rotate_colours(mode)
  if !exists('s:colours')
    let s:colours = s:colours()
  endif
  if (a:mode == 'random')
    let index = localtime() % len(s:colours)
    let name = s:colours[index]
  else
    let name = remove(s:colours, a:mode == 'reverse' ? -1 : 0)
    if a:mode == 'reverse'
      call insert(s:colours, name, 0)
    else
      call add(s:colours, name)
    endif
  endif
  execute 'colorscheme' name
  "highlight LineNr guibg=bg
  redraw
  echo 'Colour scheme:' name
endfunction

function! CommentBlock(title, ...)
  echo 'Title is:' a:title
  " If 1 or more optional args, first optional arg is introducer.
  let introducer =  a:0 >= 1  ?  a:1  :  "#"
  " If 2 or more optional args, second optional arg is boxing character.
  let box_char   =  a:0 >= 2  ?  a:2  :  "#"
  " If 3 or more optional args, third optional arg is comment width.
  let width      =  a:0 >= 3  ?  a:3  :  strlen(a:title) + 2
  " Build the comment box and put the comment inside.
  return introducer . " " . repeat(box_char, width + 2) . "\<CR>"
    \ . introducer . " " . box_char . " " . a:title . ' ' . box_char . "\<CR>"
    \ . introducer . " " . box_char . repeat(box_char, width + 1) 
endfunction

" Return the number of milliseconds beetwen the current hour and a target hour.
" Handles the case of a target hour the next day.
" Both hours should be lists composed of two elements: hours and minutes.
" Eg 11:20 pm = [23, 20]
"    09:00 am = [9, 0]
function! TimeDiff(current, target)
    let targetMilli   = (a:target[0] * 3600 + a:target[1] * 60) * 1000
    let currentMilli  = (a:current[0] * 3600 + a:current[1] * 60) * 1000

    if (a:target[0] > a:current[0] || (a:target[0] == a:current[0] && a:target[1] > a:current[1]))
        return targetMilli - currentMilli
    else
        return (24 * 3600 * 1000) + ( currentMilli - targetMilli )
    endif
endfunction

" Check if the current hour is between g:dayTime and g:nighTime
function! IsDayTime()
    let hCurrent = strftime('%H')
    let mCurrent = strftime('%M')

    if hCurrent == g:dayTime[0]
        return mCurrent >= g:dayTime[1]
    elseif hCurrent == g:nightTime[0]
        return mCurrent < g:nightTime[1]
    else
        return hCurrent > g:dayTime[0] && hCurrent < g:nightTime[0]
    endif
endfunction

" According to the current time and the nighttime, set the colorscheme and create
" a trigger for the job which will change the colorscheme
function! ScheduleNewColorscheme(timer)
    " Define colorscheme and next time depending on time of day
    if IsDayTime()
        let newColorscheme = g:colorschemeDay
        let targetDate = g:nightTime
    else
        let newColorscheme =g:colorschemeNight
        let targetDate = g:dayTime
    endif

    " Set new colorscheme
    "echom 'setting colorscheme ' . newColorscheme . ' at ' . strftime('%H:%M')
    execute 'colorscheme ' . newColorscheme

    let currentDate = [strftime('%H'), strftime('%M')]
    let startDelay = TimeDiff(currentDate, targetDate)

    " Create the trigger for the next change
    call timer_start(startDelay, 'ScheduleNewColorscheme', {}) 
endfunction

" When sourcing your vimrc set the colorscheme immediately
call timer_start(0, 'ScheduleNewColorscheme', {})

" # Commands #
command! Day execute 'colorscheme ' g:colorschemeDay
command! Night execute 'colorscheme ' g:colorschemeNight

" # Mappings #

" Make it easy to quickly edit .vimrc file.
nmap <Leader>ev :tabedit $HOME/.vimrc<cr> " i.e. type ,ev to open .vimrc file in a new tab.
"nmap <Leader>ev :tabedit $MYVIMRC<cr> " i.e. type ,ev to open .vimrc file in a new tab.
" Un-highlight search results.
nmap <Leader><space> :nohlsearch<cr>
nmap <D-b> <C-]>
nmap <silent> <F8> :call <SID>rotate_colours('normal')<cr>
nmap <silent> <S-F8> :call <SID>rotate_colours('reverse')<cr>
nmap <silent> <D-F8> :call <SID>rotate_colours('random')<cr>
imap "# <C-R>=CommentBlock(input('Enter comment: '), '"')<cr>
imap "- <C-R>=CommentBlock(input('Enter comment: '), '"', '-')<cr>

" - Buffers -
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

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

" The idea is to return to absolute line number mode when buffer loses focus
" (might or might not be useful, but doesn't hurt either way).
augroup MyNumberToggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" ############
" # Plug-ins #
" ############

" -----------
" - Airline -
" -----------

" # Settings #

" Smarter tab line.
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" ############
" # Deoplete #
" ############

" # Settings #

let g:deoplete#enable_at_startup = 1

" -------
" - FZF -
" -------

" # Settings #

" Default fzf layout - down / up / left / right
let g:fzf_layout = { 'right': '~35%' }
" [Tags] Command to generate tags file - 'ag' to ensure Git ignored files aren't tagged.
let g:fzf_tags_command = 'ag -l | ctags -L-'

" # Mappings #

" FZF buffer tags.
nmap <Leader>r :BTags<cr>
nmap <D-F12> :BTags<cr>
" FZF tags.
nmap <Leader>t :Tags<CR>
" FZF files.
nmap <Leader>f :Files<cr>
nmap <D-O> :Files<cr>
" FZF buffers.
nmap <Leader>bf :Buffers<cr>
nmap <D-E> :Buffers<cr>
" FZF recently opened files and buffers.
nmap <Leader>o :History<cr>
nmap <D-e> :History<cr>

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
  \                         : fzf#vim#with_preview('down:50%:hidden', '?'),
  \                 <bang>0)

" Show preview of files for FZF's 'Files' command.
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('down:50%'), <bang>0)

" Show preview of files for FZF's 'GFiles' command (can't figure out for 'GFiles?').
"command! -bang -nargs=? GFiles call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview('down:50%'), <bang>0)
"command! -bang -nargs=? GFiles
"  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview('down:50%'), <bang>0)
  "\  call fzf#vim#gitfiles(<q-args>, <bang>0)

" ------------
" - Undotree -
" ------------

" # Settings #

" There are 4 layouts to choose from.
let g:undotree_WindowLayout = 4

" E.g. using 'd' instead of 'days' to save some space.
let g:undotree_ShortIndicators = 1

" Width of undotree window.
if g:undotree_ShortIndicators == 1
  let g:undotree_SplitWidth = 24
else
  let g:undotree_SplitWidth = 30
endif

" Let undotree window get focus after being opened.
let g:undotree_SetFocusWhenToggle = 1

" Height of diff window.
let g:undotree_DiffpanelHeight = 7

" --------------
" - IndentLine -
" --------------

" # Settings #

"let g:indentLine_setConceal = 0
" Temporarily disabling by default due to issue where command output isn't shown.
let g:indentLine_enabled = 0

" ------------
" - Greplace -
" ------------

" # Settings #

set grepprg=ag
let g:grep_cmd_opts = '--line-numbers --noheading'

" ----------
" - Tagbar -
" ----------

" # Mappings #

nmap <D-7> :TagbarToggle<cr>

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
nmap <D-1> :NERDTreeToggle<cr>
" Vinegar-like up operation in NERDTree, while in a buffer.
nmap <buffer> <expr> - g:NERDTreeMapUpdir
" Show NERDTree in a buffer, in a Vinegar-like fashion. This mapping will run
" the 'edit' command on the current directory, which will essentially open
" NERDTree. '<C-R>=' simply computes an expression and returns the result.
nnoremap <silent> - :silent edit <C-R>=empty(expand('%')) ? '.' : expand('%:p:h')<CR><CR>

" # Auto-commands #

augroup MyNERDTree
  autocmd!
  " Have NERDTree open when Vim starts (currently disabled).
  " autocmd VimEnter * :NERDTreeToggle
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

" ------------------
" - Vim Commentary -
" ------------------

" # Mappings #

" Comment out.
nmap <D-/> gcc<cr>
xmap <D-/> gc<cr>

" -----------
" - Vimagit -
" -----------

" # Mappings #

" Commit.
nmap <D-k> :Magit<cr>

" #######
" # EOF #
" #######
