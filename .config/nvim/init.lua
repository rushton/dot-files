-- Plugin management
local Plug = vim.fn['plug#']

vim.call('plug#begin', vim.fn.stdpath('data') .. '/plugged')

Plug 'navarasu/onedark.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'morhetz/gruvbox'

-- LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

-- Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'

-- Java LSP support
Plug 'mfussenegger/nvim-jdtls'

-- Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'VonHeikemen/lsp-zero.nvim'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

-- Git support
Plug 'tpope/vim-fugitive'

-- NERDTree
Plug 'preservim/nerdtree'

Plug('junegunn/fzf', {['do'] = function() vim.fn['fzf#install']() end})
Plug 'junegunn/fzf.vim'

-- run tests in vim
Plug 'vim-test/vim-test'

Plug 'mfussenegger/nvim-dap'

vim.call('plug#end')

-- Color scheme
vim.g.onedark_config = {
    style = 'deep'
}
vim.cmd('colorscheme onedark')

-- General settings
vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

vim.opt.mouse = ''
vim.opt.termguicolors = true

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Other settings
vim.opt.visualbell = false
vim.opt.errorbells = false
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.autochdir = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.updatetime = 250
vim.opt.statusline:append('%F')

-- Custom key mappings
vim.api.nvim_set_keymap('i', 'hh', '<Esc>', {noremap = true})
vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = true})
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = true})
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true})

-- LSP configuration
vim.opt.signcolumn = 'yes'

local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

local cmp = require('cmp')

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
  },
  mapping = {
    ['<Tab>'] = function(fallback)
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
    ["<CR>"] = cmp.mapping({
     i = function(fallback)
       if cmp.visible() and cmp.get_active_entry() then
         cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
       else
         fallback()
       end
     end,
     s = cmp.mapping.confirm({ select = true }),
     c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    }),
  }
})

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float()
  end
})

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

-- Treesitter configuration
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "java", "go", "python", "scala" },
  sync_install = true,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
}

-- Go imports on save
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

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    go_org_imports()
  end
})

-- Set tabwidth to 2 for java projects
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  pattern = '*.java',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end
})

-- fzf mappings
vim.api.nvim_set_keymap('n', 'fg', ':GFiles<CR>', {noremap = true})

-- go-to next error
vim.api.nvim_set_keymap('n', 'ge', ':lua vim.diagnostic.goto_next()<CR>', {noremap = true})

-- writenext shortcut
vim.api.nvim_set_keymap('n', 'qq', ':wn<CR>', {noremap = true})

-- vim-test bindings
vim.api.nvim_set_keymap('n', '<leader>t', ':TestNearest<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<leader>T', ':TestFile<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<leader>a', ':TestSuite<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<leader>l', ':TestLast<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<leader>g', ':TestVisit<CR>', {silent = true})

-- stop lsp from interrupting with messages on startup
vim.opt.cmdheight = 2
