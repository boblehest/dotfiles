vim.opt.mouse = ''

-- color scheme
vim.opt.termguicolors = true
vim.cmd.colorscheme('everforest')

-- # Useful indicators
vim.opt.colorcolumn = {81} -- Highlight column 81
vim.cmd.highlight('ColorColumn guibg=#220000')
vim.opt.cursorline = true -- Highlight the whole line where the cursor is located
vim.opt.number = true -- Numbered lines
-- vim.opt.relativenumber = true
vim.opt.showcmd = true -- Show the current command being entered on the status line (TODO this is default, why is this here?)
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
vim.opt.foldenable = false -- fold keeps opening and closing at completely arbitrary times. Annoying.
vim.opt.hidden = true
vim.opt.scrolloff = 8
vim.opt.fileformats = {'unix', 'dos'} -- Don't want cr+lf line on any platform, but want to preserve pre-existing cr+lf
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
-- let g:terminal_scrollback_buffer_size=10000 -- TODO I can't find any docs for
-- this one, so let's remove it.
vim.opt.shortmess:append('cI')
vim.opt.synmaxcol = 160
vim.opt.wrapscan = false -- Search usually wraps without me noticing, which is annoying.
vim.opt.cpo:append('y') -- Repeatable yank commands.
-- Always show the sign column. Having it appear and disappear while editing is
-- horribly annoying.
vim.opt.signcolumn = 'yes'
vim.opt.modeline = false

-- Remove highlights (TODO Now default in neovim)
vim.keymap.set("n", "<c-l>", ":nohlsearch<CR><c-l>")
-- Automatically create a new undo point before each line-break
vim.keymap.set("i", "<CR>", "<C-G>u<CR>")
-- Make Y behave analogous to C and D (TODO Now default in neovim)
vim.keymap.set("n", "Y", "y$")

-- Make '&' preserve flags when repeating substitutions
vim.keymap.set("n", "&", ":&&<CR>")
vim.keymap.set("x", "&", ":&&<CR>")

vim.keymap.set("n", "<Leader>sf", ":Telescope find_files<CR>")
vim.keymap.set("n", "<Leader>sg", ":Telescope git_files<CR>")
vim.keymap.set("n", "<Leader>sr", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<Leader>sb", ":Telescope buffers<CR>")

-- vim.keymap.set("n", "<Leader>bd", ":call MyBufDelete()<CR>")
-- vim.keymap.set("n", "<Leader>w", ":call FixWsAndWrite()<CR>")
vim.keymap.set("n", "<Leader>q", ":q<CR>")

-- slightly better movement keys
vim.keymap.set({'n', 'v', 'o'}, ';', 'l')
vim.keymap.set({'n', 'v', 'o'}, 'l', 'k')
vim.keymap.set({'n', 'v', 'o'}, 'k', 'j')
vim.keymap.set({'n', 'v', 'o'}, 'j', 'h')
-- we just stole ; for movement keys, so remap h to function as ;
vim.keymap.set({'n', 'v', 'o'}, 'h', ';')
vim.keymap.set({'n', 'v', 'o'}, 'H', ',')
vim.keymap.del({'n', 'v', 'o'}, ',')

-- Use the same movement keys for navigation between split windows
vim.keymap.set("n", "<C-W>j", "<C-W>h")
vim.keymap.set("n", "<C-W>k", "<C-W>j")
vim.keymap.set("n", "<C-W>l", "<C-W>k")
vim.keymap.set("n", "<C-W>;", "<C-W>l")

-- Easier delete-to-black-hole
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Easier yank/paste to/from clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+y$")
vim.keymap.set("v", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("n", "<leader>P", "\"+P")

-- Mappings.
vim.keymap.set('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
-- vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>') -- TODO Now default in neovim
-- vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>') -- TODO Now default in neovim
vim.keymap.set('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')

vim.diagnostic.config({virtual_text = false}) -- I found inline text to be horribly annoying and ugly

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.keymap.set('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.keymap.set('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.keymap.set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.keymap.set('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

  -- TODO Check `:h telescope.builtin` for info on which commands are available, and their parameters.
  vim.keymap.set('n', '<space>sf', '<cmd>lua require("telescope.builtin").lsp_document_symbols{symbols="function"}<CR>', opts)
end

local servers = {
  -- clangd = {}, -- c++
  gopls = {}, -- go
  hls = {}, -- haskell
  rust_analyzer = {}, -- rust
  ruff = {}, -- python linting?
  pyright = { -- python type checking, ++?
    settings = {
      disableOrganizeImports = true, -- Ruff already does this
    },
  },
  texlab = { -- latex
    settings = {
      texlab = {
        auxDirectory = "build",
        build = {
          executable = "tectonic",
          onSave = true,
          args = {
            "-X",
            "compile",
            "%f",
            "--synctex",
            "--keep-logs",
            "--keep-intermediates",
            "--outdir",
            "build"
          },
        },
        forwardSearch = {
          executable = "zathura",
          args = {"--synctex-forward", "%l:1:%f", "%p"}
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

vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = {"*.c", "*.cpp", "*.cc", "*.h", "*.hpp"},
    callback = function(_ev)
      vim.lsp.buf.format()
    end
  })

require("telescope").setup{}

require("telescope").load_extension("ui-select")

require("which-key").setup {}
