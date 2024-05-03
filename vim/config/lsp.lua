--------------------------------------
-- LSP Configuration and Keybindings--
--------------------------------------

-- This configuration was taken from the recommended config on the project
-- README and then configured to match my preferred keybindings.

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Sets up appropriate autocompletion for neovim lua development
require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
})

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- buf_set_keymap('n', '<leader>D', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>d', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>i', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>t', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>R', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
  -- buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  -- Attach function signature helper
  cfg = {
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = "single"
    },
    hint_prefix = "",
  }
  -- require "lsp_signature".on_attach(cfg)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local servers = { "pyright", "rust_analyzer", "tsserver" }
local servers = { "rust_analyzer", "svelte", "clangd", "ruff_lsp", "openscad_lsp"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

local function organize_imports()
  -- gets the current bufnr if no bufnr is passed
  if not bufnr then bufnr = vim.api.nvim_get_current_buf() end

  -- params for the request
  local params = {
      command = "_typescript.organizeImports",
      arguments = {vim.api.nvim_buf_get_name(bufnr)},
      title = ""
  }

  -- perform a syncronous request
  -- 500ms timeout depending on the size of file a bigger timeout may be needed
  vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", params, 500)
end

-- Configure typescript server to use locally installed version
nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    commands = {
      OrganizeImports = {
        organize_imports,
        description = "Organize Imports"
      }
    },
    capabilities = capabilities,
}

nvim_lsp.bashls.setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    cmd = { "npx", "bash-language-server", "start" },
    capabilities = capabilities,
}

nvim_lsp.pylsp.setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    cmd = { "pylsp" },
    capabilities = capabilities,
}

nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = {"javascript", "javascript.jsx", "typescript", "typescript.tsx"},
    init_options = {
        linters = {
            eslint = {
                command = "./node_modules/.bin/eslint",
                rootPatterns = {".eslintrc.js"},
                debounce = 100,
                args = {
                    "--stdin",
                    "--stdin-filename",
                    "%filepath",
                    "--format",
                    "json"
                },
                sourceName = "eslint",
                parseJson = {
                    errorsRoot = "[0].messages",
                    line = "line",
                    column = "column",
                    endLine = "endLine",
                    endColumn = "endColumn",
                    message = "${message} [${ruleId}]",
                    security = "severity"
                },
                securities = {
                    [2] = "error",
                    [1] = "warning"
                }
            },
        },
        filetypes = {
            javascript = "eslint",
            typescript = "eslint",
            ["javascript.jsx"] = "eslint",
            ["typescript.tsx"] = "eslint",
        }
    },
    capabilities = capabilities,
}

nvim_lsp.arduino_language_server.setup {
    cmd = {"arduino-language-server", "-cli-config", "/Users/reecestevens/.arduino15/arduino-cli.yaml", "-clangd", "/usr/bin/clangd", "-fqbn", "adafruit:nrf52:feather52840" },
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
}

nvim_lsp.hls.setup {
    on_attach = on_attach,
    filetypes = {
        'haskell', 'lhaskell', 'cabal'
    },
    capabilities = capabilities,
}

nvim_lsp.terraformls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
}

nvim_lsp.lua_ls.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  },
    capabilities = capabilities,
})

-- Allow hiding of diagnostic messages
vim.g.diagnostics_visible = true

function _G.toggle_diagnostics()
  if vim.g.diagnostics_visible then
    vim.g.diagnostics_visible = false
    vim.lsp.diagnostic.disable()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
    print('Diagnostics are hidden')
  else
    vim.g.diagnostics_visible = true
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
      }
    )
    vim.lsp.diagnostic.enable()
    print('Diagnostics are visible')
  end
end

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>h', ':call v:lua.toggle_diagnostics()<CR>', {silent=true, noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>Q', ':Telescope diagnostics<CR>', {silent=true, noremap=true})
