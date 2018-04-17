" Line-height.
set linespace=15
" Set custom font (use _ for spaces) and set font size.
set guifont=Fira_Code:h14
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
