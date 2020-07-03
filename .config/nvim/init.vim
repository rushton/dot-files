" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('data') . '/plugged')
Plug 'scrooloose/nerdtree'
" python plugin
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'tomasr/molokai'
Plug 'nanotech/jellybeans.vim'
Plug 'skreek/skeletor.vim'
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

syntax on
filetype plugin indent on
set termguicolors

colorscheme skeletor

" Better command-line completion
set wildmenu

" highlight search
set hlsearch
" re-do the search as each character is entered
set incsearch

" Turn off bell
set novisualbell
set noerrorbells

" case insensitive search
set ignorecase

" overrides ignorecase if capital letters are used
set smartcase

" automatically indents when returning from an indented line
set autoindent

" smartly indents after returning from characters such as {
set smartindent

" automatic c program indenting
set cindent

" shows line numbers in the left hand column
set number

" minimum height a window can be
set winminheight=0


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
