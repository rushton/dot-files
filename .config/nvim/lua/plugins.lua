return {
    -- colorscheme
    {
      "navarasu/onedark.nvim", 
      lazy=false, 
      config = function()
        -- load the colorscheme here
        vim.g.onedark_config = { style = "deep" }
        vim.cmd([[colorscheme onedark]])
      end
    },

    -- lsp-zero
    {'neovim/nvim-lspconfig', config=function()
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

    end},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp', config=function()
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
    end},

    -- autocomplete
    {'hrsh7th/cmp-buffer'}, -- completion for words in the current buffer (e.g. file)
    {'hrsh7th/cmp-path'}, -- completion for paths in the filesystem

    -- Java LSP support
    {'mfussenegger/nvim-jdtls', config=function()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      
      local workspace_dir = '/Users/nrushton/.cache/jdtls/workspaces/' .. project_name
      local lombok_jar = vim.fn.stdpath('config') .. "/jdtls/lombok.jar"
      
      -- Helper function for creating keymaps
      function nnoremap(rhs, lhs, bufopts, desc)
        bufopts.desc = desc
        vim.keymap.set("n", rhs, lhs, bufopts)
      end
      
      local key_map = function(mode, key, result)
        vim.api.nvim_set_keymap(
          mode,
          key,
          result,
          {noremap = true, silent = true}
        )
      end
      
      
      -- The on_attach function is used to set key maps after the language server
      -- attaches to the current buffer
      local on_attach = function(client, bufnr)
        -- Regular Neovim LSP client keymappings
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        local dap = require('dap')
        local widgets = require('dap.ui.widgets');
      
      
      
      
        nnoremap('gD', vim.lsp.buf.declaration, bufopts, "Go to declaration")
        nnoremap('gd', vim.lsp.buf.definition, bufopts, "Go to definition")
        nnoremap('gi', vim.lsp.buf.implementation, bufopts, "Go to implementation")
        nnoremap('K', vim.lsp.buf.hover, bufopts, "Hover text")
        nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts, "Show signature")
        nnoremap('<space>wa', vim.lsp.buf.add_workspace_folder, bufopts, "Add workspace folder")
        nnoremap('<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts, "Remove workspace folder")
        nnoremap('<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts, "List workspace folders")
        nnoremap('<space>rn', vim.lsp.buf.rename, bufopts, "Rename")
        nnoremap('<space>ca', vim.lsp.buf.code_action, bufopts, "Code actions")
        vim.keymap.set('v', "<space>ca", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
          { noremap=true, silent=true, buffer=bufnr, desc = "Code actions" })
        nnoremap('<space>f', function() vim.lsp.buf.format { async = true } end, bufopts, "Format file")
      
        require("jdtls.dap").setup_dap_main_class_configs()
        require("jdtls").setup_dap({ hotcodereplace = 'auto' })
        require('dap.ext.vscode').load_launchjs()
        dap.configurations.java = {
          {
            type = 'java';
            request = 'attach';
            name = "Debug (Attach) - Remote";
            hostName = "127.0.0.1";
            port = 5005;
          },
        }
        -- debugger mappings
        local function show_debugger_widget_scopes()
            widgets.centered_float(widgets.scopes)
        end
      
        local function conditional_breakpoint()
          dap.set_breakpoint(vim.fn.input("Condition: "))
        end
      
        nnoremap('<space>D', vim.lsp.buf.type_definition, bufopts, "Go to type definition")
        nnoremap('<space>d', dap.continue, bufopts, "Start debugging")
        nnoremap('<space>ds', show_debugger_widget_scopes, bufopts, "Show debugger variables in scope.")
        nnoremap('<space>b', dap.toggle_breakpoint, bufopts, "Set breakpoint")
        nnoremap('<space>cb', conditional_breakpoint, bufopts, "Set conditional breakpoint")
        key_map('n', '<space>dr', ':lua require"dap".repl.open()<CR>')
        -- move in debug
        key_map('n', '<F5>', ':lua require"dap".continue()<CR>')
        key_map('n', '<F8>', ':lua require"dap".step_over()<CR>')
        key_map('n', '<F7>', ':lua require"dap".step_into()<CR>')
        key_map('n', '<S-F8>', ':lua require"dap".step_out()<CR>')
        -- enable completion in dap repl
        require("cmp").setup({
            enabled = function()
              return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
                  or require("cmp_dap").is_dap_buffer()
            end
        })
        require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
            sources = {
              { name = "dap" },
            },
        })
      end
      
      local config = {
          on_attach=on_attach,
          cmd = {
              '/opt/homebrew/bin/jdtls',
              "-data", workspace_dir,
              "--jvm-arg=" .. "-javaagent:" .. lombok_jar,
              "--jvm-arg=--add-modules=ALL-SYSTEM"
          },
          init_options = {
            bundles = {
                  "/Users/nrushton/.config/nvim/com.microsoft.java.debug.plugin-0.53.0.jar"
              }
          },
          root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),
          capabilities = {
              workspace = {
                  configuration = true
              },
              textDocument = {
                  completion = {
                      completionItem = {
                          snippetSupport = true
                      }
                  }
              }
          }
      }
      require('jdtls').start_or_attach(config)
    end},

    -- tree sitter for better syntax and structure recognition
    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', config=function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "java", "go", "python", "scala" },
        sync_install = true,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
        },
      }
    end},

    -- Git support
    {'tpope/vim-fugitive'},

    -- NERDTree
    {'preservim/nerdtree'},

    -- fzf
    {
      "ibhagwan/fzf-lua",
      cmd = "FzfLua",
      lazy=false,
      keys = {
        -- find
        { "fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
        { "fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
      },
    },
    -- run tests in vim
    {
      'vim-test/vim-test', 
      keys={
	{"<leader>t", "<cmd>TestNearest<CR>", desc = "Tests nearest test in the file"},
	{"<leader>T", "<cmd>TestFile<CR>", desc= "Tests the whole file"},
	{"<leader>a", "<cmd>TestSuite<CR>", desc = "Tests the whole suite"},
	{"<leader>l", "<cmd>TestLast<CR>", desc = "Tests the last test"},
	{"<leader>g", "<cmd>TestVisit<CR>"},
      }
    },
    
    -- debugger
    {'mfussenegger/nvim-dap'}
}
