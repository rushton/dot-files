call plug#begin(stdpath('data') . '/plugged')
" Using Vim-Plug
Plug 'navarasu/onedark.nvim'
call plug#end()

let g:onedark_config = {
    \ 'style': 'deep',
\}
colorscheme onedark

syntax on
filetype plugin indent on

" Disable the mouse
set mouse=

set termguicolors

"""""""""""""""""""""""""""""""
"" SEARCH
"""""""""""""""""""""""""""""""
" highlight search
set hlsearch
" re-do the search as each character is entered
set incsearch
" case insensitive search
set ignorecase
" overrides ignorecase if capital letters are used
set smartcase


" Turn off bell
set novisualbell
set noerrorbells

" smartly indents after returning from characters such as {
set smartindent

" shows line numbers in the left hand column
set number

" automatically change the directory to the current file
set autochdir

" No tabs in the source file.
" All tab characters are 4 space characters.
set tabstop=4
set shiftwidth=4
set expandtab

""""""""""""""""""""""""""""""
" Custom key mappings
""""""""""""""""""""""""""""""

" Override esc key, use hh instead (DVORAK setting)
imap hh <Esc>

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
