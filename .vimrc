""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AUTHOR: Nick Rushton (rushton.nicholas@gmail.com)
" DESCRIPTION: Custom vimrc configuration based upon my personal preference
" REQUIRED PLUGINS:
"   - NERDCommenter
"   - NerdTree
"   - FuzzyFinder
"   - TagList
"   - SnipMate
"   - PHPFolding
"   - PHPComplete
"   - Supertab
"   - Surround
" MAPING:
"   leader = \
"   - Ctrl+j
"   - Ctrl+k
"   - jj = Esc
"   - F2 = Display NerdTree
"   - F6 = Display function list
"   - \f = Display most recent files
"   - \ff= Enable fuzzy file search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on syntax highlighting
syntax on

" Allows switching from unsaved buffer without saving it and share the history for multiple files.
set hidden

" Turn on 256 color support
set t_Co=256

" Set custom color scheme
"colorscheme cleanphp
colorscheme obsidian

"Enable file type
filetype plugin on
"filetype indent on

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
set incsearch

" Turn off bell
set novisualbell
set noerrorbells

set t_vs=
set tm=500

" show matching brackets
set showmatch

" case insensitive search
set ignorecase
set smartcase

" auto indentation
set autoindent
set smartindent
set cindent

" Line number
set number

""""""""""""""""""""""""""""""
" Identation settings - per the coding standard, uses 3 spaces as a tab
""""""""""""""""""""""""""""""
set shiftwidth=4
set softtabstop=4
set tabstop=5
set expandtab
" set cinkeys=0{,0},:,0#,!,!^F

""""""""""""""""""""""""""""""
" Custom key mappings
""""""""""""""""""""""""""""""
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
" Override esc key, use jj instead
imap jj <Esc>
set wmh=0

""""""""""""""""""""""""""""""
" Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" Format the statusline
" Set statusline to this format: File Location Line:<number> [TYPE=<filetype>]
set statusline=\ %{HasPaste()}%F%m%r%h%w\ \ Line:\ %l/%L:%c\ \ [TYPE=%Y]
au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
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

""""""""""""""""""""""""""""""
" Custom PHP syntax check
""""""""""""""""""""""""""""""
" run file with PHP CLI (CTRL-M)
"autocmd FileType php noremap <C-M> :w!<CR>:!/usr/local/bin/php %<CR>

" PHP parser check (CTRL-L)
"autocmd FileType php noremap <C-L> :!/usr/local/bin/php -l %<CR>
" Same as autochdir, this is a hack to revamp it as some plug-ins doesn't
" regonize autochdir
autocmd BufEnter * lcd %:p:h
nmap <silent> nd :NERDTreeToggle<CR>
hi Directory guifg=#FF0000 ctermfg=red
map <F9> :TlistToggle<CR>
map th :tabfirst<CR>
map tj :tabnext<CR>
map tk :tabprev<CR>
map tl :tablast<CR>
map tt :tabedit<Space>
map tn :tabnext<Space>
map tm :tabm<Space>

""""""""""""""""""""""""""""""
" PHP settings
""""""""""""""""""""""""""""""
let g:DisableAutoPHPFolding = 1
let php_smart_members = 1
let php_show_semicolon = 0
let php_highlight_quotes = 1
let php_special_functions = 0
let php_htmlInStrings = 0
let php_alt_comparisons = 0
let php_smart_semicolon = 0
let php_sql_query=1
let php_htmlInStrings=1


" Don't use the PHP syntax folding
setlocal foldmethod=manual

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fuzzyfinder settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" After bringing up FufFile, **/<filename>
"nmap <leader>ff :FufFile **/<CR>
"omap <silent> iw <Plug>CamelCaseMotion_iw
"xmap <silent> iw <Plug>CamelCaseMotion_iw
"omap <silent> ib <Plug>CamelCaseMotion_ib
"xmap <silent> ib <Plug>CamelCaseMotion_ib
"omap <silent> ie <Plug>CamelCaseMotion_ie
"xmap <silent> ie <Plug>CamelCaseMotion_ie

inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>

" json
autocmd BufRead,BufNewFile *.json set filetype=javascript

function! KillTrailingWhitespace()
  let winview = winsaveview()
  exec ':%s/\s\+$//e'
  call winrestview(winview)
endfunction

autocmd BufWritePre * :call KillTrailingWhitespace()

call pathogen#infect()
call pathogen#helptags()

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
set tags=/usr/local/tags/tags
let g:go_fmt_command = "goimports"

" pylint
set makeprg=pylint\ --reports=n\ --output-format=parseable\ %:p
set errorformat=%f:%l:\ %m

" ctags stuff
set tags=/tmp/my_ctags
