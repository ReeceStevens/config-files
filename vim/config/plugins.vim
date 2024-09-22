-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

-- Start setup
lazy.setup({
  -- General Plugins
  { "tpope/vim-obsession" }, -- Easier hooks to vim sessions
  {
    "scrooloose/nerdtree",
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
  },
  { "tpope/vim-rhubarb" }, -- github Gbrowse support
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
  { "rust-lang/rust.vim" },
  { "leafgarland/typescript-vim" },
  { "nvie/vim-flake8" },
  { "moll/vim-node" },
  { "kchmck/vim-coffee-script" },
  { "yuezk/vim-js" },
  { "maxmellon/vim-jsx-pretty" },
  { "prettier/vim-prettier" },
  { "kergoth/vim-bitbake" },
  {
    "evanleck/vim-svelte",
    config = function()
      vim.g.svelte_preprocessors = {'typescript'}
    end,
  },

  -- Miscellaneous Plugins
  { "flazz/vim-colorschemes" },
  { "morhetz/gruvbox" },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "rcarriga/cmp-dap",
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "folke/neodev.nvim",
    },
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
  },

  { "psf/black", branch = "stable" },
  { "fisadev/vim-isort" },

  {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_background = 'hard'
      vim.g.everforest_better_performance = 1
    end,
  },

  { "NLKNguyen/papercolor-theme" },

  { "nvim-orgmode/orgmode", branch = "reece/clock-fixes" },
  { "chipsenkbeil/org-roam.nvim" },

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
  { "stevearc/dressing.nvim" },
  { "MunifTanjim/nui.nvim" },
  {
    "HakonHarnes/img-clip.nvim",
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
  },
  {
    "yetone/avante.nvim",
    branch = "main",
    build = "make",
    config = function()
      require('avante_lib').load()
      require('avante').setup()
    end,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "David-Kunz/jester",
      "theHamsta/nvim-dap-virtual-text",
      "jbyuki/one-small-step-for-vimkind",
    },
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
  { "petertriho/cmp-git" },

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
})

-- Telescope config
require('telescope').load_extension('fzf')

-- Treesitter config
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
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
