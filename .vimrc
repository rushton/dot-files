""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AUTHOR: Nick Rushton (rushton.nicholas@gmail.com)
" DESCRIPTION: Custom vimrc configuration based upon my personal preference
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set viminfo=%,\"100,'10,/50,:100,h,f0,n~/.vim/cache/.viminfo
" initialize pathogen
execute pathogen#infect()

" Turn on syntax highlighting
syntax on

" Allows switching from unsaved buffer without saving it and share the history for multiple files.
set hidden

" Turn on 256 color support
set t_Co=256

" Set custom color scheme
colorscheme obsidian

"Enable file type
filetype plugin on
filetype indent on

" Sync working directory with current working directory
set autochdir

" Load modified files automatically
set autoread

" Better command-line completion
set wildmenu

" Display commands
set showcmd

" highlight search
set hlsearch
" re-do the search as each character is entered
set incsearch

" Turn off bell
set novisualbell
set noerrorbells

set t_vs=
set timeoutlen=250

" highlight matching brackets, parens, etc by highlighting the matching
" character
set showmatch

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

" replace TAB key with spaces
set expandtab

" number of spaces to use when auto indenting, such as in cindent
set shiftwidth=4

" number of spaces to use when hitting TAB
set softtabstop=4
set tabstop=4

" set cinkeys=0{,0},:,0#,!,!^F

""""""""""""""""""""""""""""""
" Custom key mappings
""""""""""""""""""""""""""""""
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

" Override esc key, use jj instead
imap jj <Esc>

" minimum height a window can be
set winminheight=0

" Always hide the statusline
set laststatus=2

" Format the statusline
if has('statusline')
   set laststatus=2
   " Broken down into easily includeable segments
   set statusline=%{HasPaste()} " show whether in paste mode on the status line
   set statusline+=%F%m%r%h%w\  " Options
   set statusline+=%{fugitive#statusline()} "  Git Hotness
   set statusline+=\ [%{&ff}/%Y]            " filetype
   set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

" shows PASTE MODE when in paste mode
function! HasPaste()
    if &paste
        return '<PASTE MODE>  '
    else
        return ''
    endif
endfunction

""""""""""""""""""""""""""""""
" Ctags settings
""""""""""""""""""""""""""""""
" Location of ctags
let Tlist_Ctags_Cmd = '/usr/bin/ctags'

"let tlist_php_settings = 'php;c:class;f:function;d:constant'
let Tlist_Sort_Type = "name"

" Show small meny
let Tlist_Compart_Format = 1

" If you are the last, kill yourself
let Tlist_Exist_OnlyWindow = 1

" Do not close tags for other files
let Tlist_File_Fold_Auto_Close = 0

" Do not show folding tree
let Tlist_Enable_Fold_Column = 0

" close all folds except for current file
let Tlist_File_Fold_Auto_Close = 1

" make tlist pane active when opened
let Tlist_GainFocus_On_ToggleOpen = 1

" width of window
let Tlist_WinWidth = 20
" close tlist when a selection is made
let Tlist_Close_On_Select = 1


""""""""""""""""""""""""""""""
" Vim7 specific settings
" Some hosts have vim6 and vim7 installed
" Make sure you aliased vim=<path>/vim7
""""""""""""""""""""""""""""""
if version>=700
   autocmd FileType python set omnifunc=pythoncomplete#Complete
   autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
   autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
   autocmd FileType css set omnifunc=csscomplete#CompleteCSS
   autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
   autocmd FileType php set omnifunc=phpcomplete#CompletePHP
   autocmd FileType c set omnifunc=ccomplete#Complete

   " automatically save changes when jumping from file to file
   set autowrite
endif

" alias for filetype setting on json files
autocmd BufRead,BufNewFile *.json set filetype=javascript

" removes any trailing white spaces
function! KillTrailingWhitespace()
  let winview = winsaveview()
  exec ':%s/\s\+$//e'
  call winrestview(winview)
endfunction

autocmd BufWritePre * :call KillTrailingWhitespace()


" Plugin configs
let g:CommandTAcceptSelectionMap = '<C-t>'
let g:CommandTAcceptSelectionTabMap = '<CR>'
let mapleader = ","

" KEY MAPPINGS
" " Minibuf keys
map <leader>f :tabnext<CR>
map <leader>b :tabprevious<CR>

" " use ctrl-j/k/l/h to move around splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nmap <leader>a <Esc>:Ack!

" set tag file
set tags=./git/tags-dep,tags-dep,./.git/tags
let g:go_fmt_command = "goimports"

" pylint
set makeprg=pylint\ --reports=n\ --output-format=parseable\ %:p
set errorformat=%f:%l:\ %m

" directory to store swap files
set directory=$HOME/.vimswap/,.

" minimum lines to keep above and below cursor
set scrolloff=3

" alias ; to : if lazily lifting off the shift key
nnoremap ; :

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" can be set if using neovim
" set termguicolors

" hide swap and pyc files in vim directory listing
let g:netrw_list_hide= '.*\.sw[a-z]$,.*\.pyc$'

" https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
set nomodeline
