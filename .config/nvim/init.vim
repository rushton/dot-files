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

" Git support
Plug 'tpope/vim-fugitive'

" NERDTree
Plug 'preservim/nerdtree'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
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

" Sets the time to wait before a hover action initiates
set updatetime=250

" Show the full file path in the status line
set statusline+=%F
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

" Autoformat files prior to write
autocmd BufWritePre * :silent! lua vim.lsp.buf.format({async=false})

" LSP support
lua <<EOF
local lsp = require('lsp-zero')

function getrootdir()
  return vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, { upward = true })[1])
end
lsp.preset('recommended')
lsp.configure('jdtls', {
        cmd = {
        "jdtls",
        "--jvm-arg=" .. string.format(
            "-javaagent:%s",
            require("mason-registry").get_package("jdtls"):get_install_path() .. "/lombok.jar"
        ),
    },
    root_dir = getrootdir
})
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
  'pyright',
  'vimls',
  'jsonls',
})
EOF

autocmd CursorHold * lua vim.diagnostic.open_float()
lua <<EOF
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
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

" go imorts on save
lua <<EOF
  -- …

  function go_org_imports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end
EOF

autocmd BufWritePre *.go lua go_org_imports()

" fzf mappings
nnoremap fg :GFiles<CR>

" writenext shortcut
nnoremap qq :wn<CR>
