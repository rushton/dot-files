require("config.lazy")
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

-- go-to next error
vim.api.nvim_set_keymap('n', 'ge', ':lua vim.diagnostic.goto_next()<CR>', {noremap = true})

-- writenext shortcut
vim.api.nvim_set_keymap('n', 'qq', ':wn<CR>', {noremap = true})

-- stop lsp from interrupting with messages on startup
vim.opt.cmdheight = 2
