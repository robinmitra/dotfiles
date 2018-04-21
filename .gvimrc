" Line-height.
set linespace=1 " anything above this screws up airline symbol alignment!
" Set custom font (use _ or \ for spaces) and set font size.
set guifont=Fira\ Code:h15
"set guifont=Fira\ Mono\ for\ Powerline:h14 " Ligature not supported unfortunnately.
" Enable => ligature support.
set macligatures
" Disable ugly GUI tabs in MacVim.
set guioptions-=e

" Disable scrollbars, whether or not a vertical split is present.
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

" Disable conflicting MacVim bindings.
macmenu Tools.Make key=<nop>
"macmenu File.Save\ All key=<nop>
"macmenu File.Save\ As\.\.\. key=<nop>
