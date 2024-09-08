vim.opt.mouse = ''

-- color scheme
vim.opt.termguicolors = true
vim.cmd.colorscheme('everforest')

-- # Useful indicators
vim.opt.colorcolumn = {81} -- Highlight column 81
vim.cmd.highlight('ColorColumn guibg=#220000')
vim.opt.cursorline = true -- Highlight the whole line where the cursor is located
vim.opt.number = true -- Numbered lines
-- TODO Get a new statusline/bar
-- vim.opt.statusline = %-3.3n%f%h%m%r%w\ [type=%{strlen(&ft)?&ft:'none'}]
-- 			\\ [enc=%{strlen(&fenc)?&fenc:&enc}]
-- 			\\ %=char:\ %03b,0x%02B\ \ \ \ pos:\ %-10.(%l,%c%V%)\ %P

-- # Vim backup configuration
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.o.shada = "'15,<50,s1,h"

-- # Search options
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- # Misc
vim.opt.cmdheight = 0
vim.opt.foldenable = false -- fold keeps opening and closing at completely arbitrary times. Annoying.
vim.opt.hidden = true
vim.opt.scrolloff = 8
vim.opt.fileformats = {'unix', 'dos'} -- Don't want cr+lf EOL format by default on any platform, but want to preserve pre-existing EOL format on files I edit
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.shortmess:append('cI')
vim.opt.synmaxcol = 160
vim.opt.wrapscan = false -- Notify me if wrap occurs while going to next search result
vim.opt.cpo:append('y') -- Repeatable yank commands.
-- Always show the sign column. Having it appear and disappear while editing is
-- horribly annoying.
vim.opt.signcolumn = 'yes'
vim.opt.modeline = false

-- Automatically create a new undo point before each line-break
vim.keymap.set('i', '<CR>', '<C-G>u<CR>')

-- Make '&' preserve flags when repeating substitutions
vim.keymap.set('n', '&', '<cmd>&&<CR>')
vim.keymap.set('x', '&', '<cmd>&&<CR>')

vim.keymap.set('n', '<Leader>sf', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', '<Leader>sg', '<cmd>Telescope git_files<CR>')
vim.keymap.set('n', '<Leader>sr', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<Leader>sb', '<cmd>Telescope buffers<CR>')

-- slightly better movement keys
vim.keymap.set({'n', 'v', 'o'}, ';', 'l')
vim.keymap.set({'n', 'v', 'o'}, 'l', 'k')
vim.keymap.set({'n', 'v', 'o'}, 'k', 'j')
vim.keymap.set({'n', 'v', 'o'}, 'j', 'h')
-- we just stole ; for movement keys, so remap h to function as ;
vim.keymap.set({'n', 'v', 'o'}, 'h', ';')
vim.keymap.set({'n', 'v', 'o'}, 'H', ',')
vim.keymap.del({'n', 'v', 'o'}, ',')

vim.keymap.set({'n', 'v', 'o'}, '<Up>', '<Nop>')
vim.keymap.set({'n', 'v', 'o'}, '<Down>', '<Nop>')
vim.keymap.set({'n', 'v', 'o'}, '<Left>', '<Nop>')
vim.keymap.set({'n', 'v', 'o'}, '<Right>', '<Nop>')

-- Use the same movement keys for navigation between split windows
vim.keymap.set('n', '<C-W>j', '<C-W>h')
vim.keymap.set('n', '<C-W>k', '<C-W>j')
vim.keymap.set('n', '<C-W>l', '<C-W>k')
vim.keymap.set('n', '<C-W>;', '<C-W>l')

-- Easier delete-to-black-hole
vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')

-- Easier yank/paste to/from clipboard
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+y$')
vim.keymap.set('v', '<leader>Y', '"+Y')
vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')

-- Close a buffer without closing the split window.
local bd_preserve_split = function()
  if vim.api.nvim_get_option_value('mod', {}) then
    -- The bd command will fail because the buffer is modified,
    -- so instead of switching to another buffer and then issuing
    -- the failing command, we will just issue it from the current buffer
    -- (so the user gets the error message)
    vim.cmd('bd')
  else
    vim.cmd('bp')
    vim.cmd('bd #')
  end
end

-- Buffer saving/closing
vim.keymap.set('n', '<leader>bd', bd_preserve_split)
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>')
vim.keymap.set('n', '<Leader>q', '<cmd>q<CR>')

-- Mappings.
vim.keymap.set('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
-- The next two can be removed when we get the following PR:
-- https://github.com/neovim/neovim/pull/29593
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')

vim.diagnostic.config({virtual_text = false}) -- I found inline text to be annoying and ugly

-- TODO Have another look at your keymap. There's probably many new useful
-- commands you can add bindings for.
local on_attach = function(client, bufnr)
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.keymap.set('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.keymap.set('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.keymap.set('n', '<space>d', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.keymap.set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
  vim.keymap.set('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

  vim.keymap.set('n', '<space>sf', '<cmd>lua require("telescope.builtin").lsp_document_symbols{symbols="function"}<CR>', opts)
end

local servers = {
  -- clangd = {}, -- c++
  gopls = {}, -- go
  hls = {}, -- haskell
  rust_analyzer = {}, -- rust
  ruff = {}, -- python linting?
  pyright = {
    settings = {
      disableOrganizeImports = true,
      disableTaggedHints = true,
    },
    python = {
      analysis = {
        diagnosticSeverityOverrides = {
          -- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#type-check-diagnostics-settings
          reportUndefinedVariable = 'none',
        },
      },
    },
  },
  texlab = { -- latex
    settings = {
      texlab = {
        auxDirectory = 'build',
        build = {
          executable = 'tectonic',
          onSave = true,
          args = {
            '-X',
            'compile',
            '%f',
            '--synctex',
            '--keep-logs',
            '--keep-intermediates',
            '--outdir',
            'build'
          },
        },
        forwardSearch = {
          executable = 'zathura',
          args = {'--synctex-forward', '%l:1:%f', '%p'}
        }
      }
    }
  }
}

local lspconfig = require('lspconfig')
for lsp_name, lsp_settings in pairs(servers) do
  lsp_settings.on_attach = on_attach
  lspconfig[lsp_name].setup(lsp_settings)
end

-- TODO Add corresponding setup for all languages? Or somehow make sure I
-- autoformat files more often
vim.api.nvim_create_autocmd({'BufWritePre'}, {
    pattern = {'*.c', '*.cpp', '*.cc', '*.h', '*.hpp'},
    callback = function(_ev)
      vim.lsp.buf.format()
    end
  })

-- plugins
vim.g.better_whitespace_enabled = 1

require('telescope').setup{}
require('telescope').load_extension('ui-select')
require('which-key').setup{}
require('nvim-treesitter.configs').setup{
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
    },
  },
}
require('nvim-surround').setup{}
