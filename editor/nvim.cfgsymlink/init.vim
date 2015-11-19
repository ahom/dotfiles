let g:python_host_prog='/usr/bin/python2'

call plug#begin()
Plug 'bling/vim-airline'
Plug 'godlygeek/tabular'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }

Plug 'euclio/vim-markdown-composer', { 'do': 'cargo build --release' }
Plug 'Valloric/YouCompleteMe', { 'do': '/usr/bin/python2 install.py --clang-completer --gocode-completer'  }
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

set omnifunc=syntaxcomplete#Complete
autocmd FileType typescript setlocal completeopt+=menu,preview

" Workaround for nvim until this is fixed
" https://github.com/neovim/neovim/issues/3211  
map <F1> <Del>
imap <F1> <Del>

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'
