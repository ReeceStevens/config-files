-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Start setup
require("lazy").setup({
  install = { colorscheme = {"molokai"} },
  spec = {
      -- General Plugins
      {
          -- Easier hooks to vim sessions
          "tpope/vim-obsession",
          lazy = true,
          cmd = "Obsession",
      },
      {
        "scrooloose/nerdtree",
        lazy = true,
        cmd = "NERDTreeToggle",
        keys = {
          { "<leader>1", "<cmd>NERDTreeToggle<CR>", desc = "Toggle NERDTree" },
        },
        config = function()
          vim.g.NERDTreeIgnore = { [[\~$]], [[\.pyc]], [[__pycache__]], [[\.fifo]] }
          vim.g.NERDTreeMapHelp = '<f1>'
        end,
      },

      -- Movement Plugins
      { "tpope/vim-unimpaired" }, -- Convenient mappings for the quickfix list

      -- Aesthetics
      {
        "vim-airline/vim-airline",
        dependencies = { "vim-airline/vim-airline-themes" },
        config = function()
          vim.g.airline_symbols_ascii = 1
          vim.g.airline_skip_empty_sections = 1
          vim.g.airline_theme = 'badwolf'
          vim.g.airline_extensions_tabline_enabled = 1
          vim.g.airline_extensions_virtualenv_enabled = 1
          vim.g.airline_extensions_whitespace_enabled = 0
          vim.g.airline_extensions_obsession_enabled = 1
          vim.g.airline_section_y = '' -- Disable file encoding section
        end,
      },

      -- File Editing Plugins
      {
        "tpope/vim-fugitive",
        keys = {
          { "<leader>5", "<cmd>Git blame<CR>", desc = "Git blame" },
        },
        lazy = false,
        dependencies = {
          "tpope/vim-rhubarb",
        },
      },
      {
        "airblade/vim-gitgutter",
        config = function()
          vim.g.gitgutter_sign_added = '+'
          vim.g.gitgutter_sign_modified = '∙'
          vim.g.gitgutter_sign_removed = '-'
          vim.g.gitgutter_sign_modified_removed = '∙'
        end,
      },
      { "tpope/vim-commentary" }, -- context-aware comments with `gc`
      {
        "majutsushi/tagbar",
        cmd = "TagbarToggle",
        keys = {
          { "<leader>2", "<cmd>TagbarToggle<CR>", desc = "Toggle Tagbar" },
        },
        config = function()
          vim.g.tagbar_iconchars = {'+', '-'}
          vim.g.airline_extensions_tagbar_enabled = 0
        end,
      },
      {
        "corntrace/bufexplorer",
        cmd = "BufExplorer",
        keys = {
          { "<leader>3", "<cmd>BufExplorer<CR>", desc = "Open BufExplorer" },
        },
        config = function()
          vim.g.bufExplorerDefaultHelp = 0
        end,
      },
      {
        "simnalamburt/vim-mundo",
        cmd = "MundoToggle",
        keys = {
          { "<leader>4", "<cmd>MundoToggle<CR>", desc = "Toggle Mundo" },
        },
        config = function()
          vim.g.mundo_right = 1
          vim.g.mundo_help = 0
        end,
      },

      -- Filetype Specific Support
      {
          "rust-lang/rust.vim",
          ft = "rust",
      },
      {
          "leafgarland/typescript-vim",
          ft = {"typescript", "typescriptreact", "typescript.tsx"},
      },
      {
          "kchmck/vim-coffee-script",
          ft = "coffee",
      },
      { "yuezk/vim-js", ft = "javascript" },
      { "maxmellon/vim-jsx-pretty", ft="javascript.jsx" },
      {
          "prettier/vim-prettier",
          cmd = {
            "Prettier",
            "PrettierAsync",
            "PrettierPartial",
            "PrettierFragment",
            "PrettierVersion",
            "PrettierCli",
            "PrettierCliPath",
            "PrettierCliVersion",
          }
      },
      {
          "kergoth/vim-bitbake",
          ft = "bitbake",
      },
      {
        "evanleck/vim-svelte",
        ft = "svelte",
        config = function()
          vim.g.svelte_preprocessors = {'typescript'}
        end,
      },

      -- Miscellaneous Plugins
      { "flazz/vim-colorschemes" },
      { "morhetz/gruvbox" },

      -- Autocomplete
      { import = "autocomplete" },

      -- LSP
      {
        "neovim/nvim-lspconfig",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          {"folke/neodev.nvim", opts = { library = { plugins = { "nvim-dap-ui" }, types = true } } }
        },
        config = function()
            local nvim_lsp = require('lspconfig')
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
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
            nvim_lsp.ts_ls.setup {
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
        end
      },

      -- Fuzzy search
      {
        "junegunn/fzf",
        build = function()
          vim.fn["fzf#install"]()
        end,
      },
      { "junegunn/fzf.vim" },
      {
        "ibhagwan/fzf-lua",
        branch = "main",
        keys = {
          { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "FzfLua live grep" },
          { "<leader>fd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "FzfLua diagnostics" },
        },
      },

      -- Markdown table alignment
      { "junegunn/vim-easy-align" },

      -- Telescope for file searching
      {
        "nvim-telescope/telescope.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            require('telescope').load_extension('fzf')
        end,
      },

      { "psf/black", branch = "stable" },

      {
        "sainnhe/everforest",
        config = function()
          vim.g.everforest_background = 'hard'
          vim.g.everforest_better_performance = 1
        end,
      },

      { "NLKNguyen/papercolor-theme" },

      {
          "nvim-orgmode/orgmode",
          ft = "org",
          config = function()
              local orgmode = require('orgmode')
              orgmode.setup({
                org_agenda_files = {
                    "~/innolitics/notes/org-notes/*.org",
                    "~/innolitics/notes/org-notes/work/*.org",
                    "~/innolitics/notes/org-notes/org-roam/**/*",
                    "~/innolitics/notes/org-notes/work/management/*.org",
                  },
                  org_default_notes_file = '~/innolitics/notes/org-notes/refile.org',
                  org_todo_keywords = {'TODO', 'IN_PROGRESS', 'BLOCKED', 'DONE'},
                  org_capture_templates = {
                    t = {
                        description = 'Task',
                        template = '* TODO %?\nSCHEDULED: %t\n:PROPERTIES:\n:CREATED_ON: %u\n:END:',
                        properties = { empty_lines = 1 } },
                  },
                  org_startup_indented = false,
                  org_startup_folded = 'showeverything',
                  org_adapt_indentation = false,
                  org_todo_keyword_faces = {
                    TODO = ':foreground red', -- overrides builtin color for `TODO` keyword
                    IN_PROGRESS = ':foreground orange', -- overrides builtin color for `TODO` keyword
                    DONE = ':foreground green :weight bold', -- overrides builtin color for `TODO` keyword
                  },
                  calendar_week_start_day = 0,
              })
              -- Custom lua plugin for exporting to Harvest
              require('orgmode-harvest')
              require('orgmode-backlinks')

              vim.api.nvim_set_hl(0, '@org.agenda.deadline', {link = 'Error'})
              vim.api.nvim_set_hl(0, '@org.agenda.scheduled', {link = 'Function'})
              vim.api.nvim_set_hl(0, '@org.agenda.scheduled_past', {link = 'DiagnosticWarn'})
              vim.api.nvim_set_hl(0, 'OctoEditable', {bg = "#1B1D1F"})

              -- To conceal org hyperlinks, which can be somewhat verbose
              --autocmd BufRead,BufNewFile *.txt setfiletype text
              vim.api.nvim_create_autocmd(
                  {"BufRead", "BufNewFile"}, {
                      pattern = {"*.org"},
                      command = "setlocal conceallevel=1",
                  }
              )

              vim.cmd [[highlight Headline1 guibg=#1e2718]]
              vim.cmd [[highlight Headline2 guibg=#21262d]]
              vim.cmd [[highlight CodeBlock guibg=#242424]]
              vim.cmd [[highlight Dash guibg=#D19A66 gui=bold]]
          end
      },
      {
          "chipsenkbeil/org-roam.nvim",
          ft = "org",
          opts = {
              directory = "~/innolitics/notes/org-notes/org-roam",
              bindings = {
                prefix = "<LocalLeader>n",
              },
          }
      },

      {
        "github/copilot.vim",
        config = function()
          vim.g.copilot_node_command = "~/.nodenv/versions/20.11.0/bin/node"
          vim.g.copilot_no_tab_map = true
          vim.cmd([[imap <expr> <Plug>(vimrc:copilot-dummy-map) copilot#Accept("\<Tab>")]])
          vim.g.copilot_filetypes = {
            ['dap-repl'] = false,
          }
        end,
      },

      {
        "CopilotC-Nvim/CopilotChat.nvim",
        opts = {
          show_help = "yes",
          prompts = {
            Explain = "Explain how it works.",
            Review = "Review the following code and provide concise suggestions.",
            Tests = "Briefly explain how the selected code works, then generate unit tests.",
            Refactor = "Refactor the code to improve clarity and readability.",
          },
        },
        build = function()
          vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
        end,
        event = "VeryLazy",
      },

      -- Avante setup (cursor-like LLM integration)
      {
        "yetone/avante.nvim",
        event = "VeryLazy",
        branch = "main",
        build = "make",
        config = function()
          require('avante_lib').load()
          require('avante').setup()
        end,
        dependencies = {
              "nvim-lua/plenary.nvim",
              "stevearc/dressing.nvim",
              "MunifTanjim/nui.nvim",
              {
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                  default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                      insert_mode = true,
                    },
                    use_absolute_path = true,
                  },
                },
              },
              {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                  file_types = {'Avante'},
                },
                ft = "Avante",
              },
        }
      },

      -- Debugging
      {
        "mfussenegger/nvim-dap",
        dependencies = {
          "nvim-neotest/nvim-nio",
          {
            "rcarriga/nvim-dap-ui",
            opts = {
              controls = {
                  element = "repl",
                  enabled = false,
              }
            }
          },
          {
            "mfussenegger/nvim-dap-python",
            config = function()
              require('dap-python').setup('~/.vim/python-virtual-env/nvim-venv/bin/python')
            end
          },
          "David-Kunz/jester",
          { "theHamsta/nvim-dap-virtual-text", opts = {} },
          "jbyuki/one-small-step-for-vimkind",
        },
        config = function()
            local dap = require('dap')
            dap.adapters.firefox = {
              type = 'executable',
              command = 'node',
              args = {os.getenv('HOME') .. '/.vim/vscode-firefox-debug/dist/adapter.bundle.js'},
            }

            dap.configurations.lua = {
              {
                type = 'nlua',
                request = 'attach',
                name = "Attach to running Neovim instance",
              }
            }
            dap.adapters.nlua = function(callback, config)
              callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
            end

            vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require"dap".continue()<CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>db', ':lua require"dap".toggle_breakpoint()<CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>dB', ':lua require"dap".toggle_breakpoint(vim.fn.input(\'Breakpoint condition: \'))<CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require"dap".step_into()<CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>do', ':lua require"dap".step_over()<CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>di', ':lua require"dapui".toggle()<CR>', {noremap = true, silent = true})

            vim.api.nvim_set_keymap('n', '<leader>dv', ':lua require"osv".launch({port = 8086})<CR>', {noremap = true, silent = true})
        end
      },

      {
        "pwntester/octo.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons",
        },
        config = function()
          require("octo").setup({
            suppress_missing_scope = {
              projects_v2 = true,
            }
          })
          local opts = { noremap = true, silent = true }
          vim.api.nvim_set_keymap('n', '<leader>gi', ':Octo issue search<CR>', opts)
          vim.api.nvim_set_keymap('n', '<leader>gI', ':Octo issue create<CR>', opts)
          vim.api.nvim_set_keymap('n', '<leader>gp', ':Octo pr search<CR>', opts)
          vim.api.nvim_set_keymap('n', '<leader>gc', ':Octo comment add<CR>', opts)
          vim.api.nvim_set_keymap('n', '<leader>gla', ':Octo label add<CR>', opts)
          vim.api.nvim_set_keymap('n', '<leader>glr', ':Octo label remove<CR>', opts)
          vim.api.nvim_set_keymap('n', '<leader>gb', ':Octo issue browser<CR>', opts)
        end,
      },
      {
         "petertriho/cmp-git",
         config = true
      },

      {
        "samjwill/nvim-unception",
        init = function()
          vim.g.unception_open_buffer_in_new_tab = true
        end,
      },

      { "ReeceStevens/vim-reviewer" },
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup()
        end,
      },

      { "ii14/neorepl.nvim" },

      {
        "stevearc/profile.nvim",
        config = function()
          local should_profile = os.getenv("NVIM_PROFILE")
          if should_profile then
            require("profile").instrument_autocmds()
            if should_profile:lower():match("^start") then
              require("profile").start("*")
            else
              require("profile").instrument("*")
            end

            local function toggle_profile()
              local prof = require("profile")
              if prof.is_recording() then
                prof.stop()
                vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
                  if filename then
                    prof.export(filename)
                    vim.notify(string.format("Wrote %s", filename))
                  end
                end)
              else
                prof.start("*")
              end
            end

            vim.keymap.set("", "<f1>", toggle_profile)
          end
        end,
      },
    },
})

-- Telescope config
-- require('telescope').load_extension('fzf')

-- Treesitter config
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = {'org', 'orgagenda', 'markdown'},
    disable = { "c", "rust", "python", "tsx", "typescript", "yaml", "toml", "typescript.tsx", "typescriptreact", "gitcommit" },
    additional_vim_regex_highlighting = {'org'},
  },
  ensure_installed = {'org'},
}

-- Copilot Chat default keybindings
vim.api.nvim_set_keymap('n', '<leader>ccb', '<cmd>CopilotChatBuffer<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cce', '<cmd>CopilotChatExplain<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cct', '<cmd>CopilotChatTests<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<leader>ccv', ':CopilotChatVisual<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<leader>ccx', ':CopilotChatInPlace<cr>', { noremap = true, silent = true })
