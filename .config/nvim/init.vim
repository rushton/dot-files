call plug#begin(stdpath('data') . '/plugged')
" Using Vim-Plug
Plug 'navarasu/onedark.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'morhetz/gruvbox'

" LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'

"  Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'VonHeikemen/lsp-zero.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


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
autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = false })
autocmd BufWritePre *.java lua vim.lsp.buf.format({ async = false })


"" syntax highlight all the golang things
" let g:go_highlight_build_constraints = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_format_strings = 1
" let g:go_highlight_function_calls = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_generate_tags = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_structs = 1
" let g:go_highlight_types = 1

" LSP support
lua <<EOF
local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.setup()
lsp.set_preferences({
  suggest_lsp_servers = true,
  setup_servers_on_start = true,
  set_lsp_keymaps = true,
  configure_diagnostics = true,
  cmp_capabilities = true,
  manage_nvim_cmp = true,
  call_servers = 'local',
  sign_icons = {
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = ''
  }
})
lsp.ensure_installed({
  'jdtls',
  'gopls',
  'bashls',
})
EOF

" Treesitter configuration
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "java", "go", "python", "scala" },
  sync_install = true,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
}
EOF
