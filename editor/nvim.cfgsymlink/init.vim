call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'bling/vim-airline'
Plug 'godlygeek/tabular'
call plug#end()

syntax on

" Wrap gitcommit file types at the appropriate length
filetype indent plugin on
set tabstop=4
set shiftwidth=4
set expandtab

set listchars=tab:>-
set list

set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'
