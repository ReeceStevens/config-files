call plug#begin('~/.vim/plugs')

" General Plugs
Plug 'tpope/vim-obsession'        " Easier hooks to vim sessions

" Show the current working directory in a nice tree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    noremap <silent> <leader>1 :NERDTreeToggle<CR>
    let NERDTreeIgnore = ['\~$', '\.pyc', '__pycache__', '\.fifo']
    let NERDTreeMapHelp = '<f1>'

"" Movement Plugs
Plug 'tpope/vim-unimpaired'       " Convenient mappings for the quickfix list

"" Asthetics
Plug 'vim-airline/vim-airline'    " Statusline
    let g:airline_symbols_ascii = 1
    let g:airline_skip_empty_sections = 1
    let g:airline_theme='badwolf'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#virtualenv#enabled = 1
    let g:airline#extensions#whitespace#enabled = 0
    let g:airline#extensions#obsession#enabled = 1
    let g:airline_section_y = '' " Disable file encoding section
Plug 'vim-airline/vim-airline-themes'


"" File Editing Plugs
Plug 'tpope/vim-fugitive'         " The all-powerful git plugin
    noremap <silent> <leader>5 :Git blame<CR>
Plug 'tpope/vim-rhubarb' " github Gbrowse support
" NOTE: bitbucket plugin seems to be continually throwing errors. Disabling
" until I have the need to work on a bitbucket project again.
" Plug 'tommcdo/vim-fubitive' " bitbucket Gbrowse support
Plug 'airblade/vim-gitgutter'
    let g:gitgutter_sign_added = '+'
    let g:gitgutter_sign_modified = '∙'
    let g:gitgutter_sign_removed = '-'
    let g:gitgutter_sign_modified_removed = '∙'
Plug 'tpope/vim-commentary' " context-aware comments with `gc`
Plug 'majutsushi/tagbar' " Show the ctags in a file
    let g:tagbar_iconchars = ['+', '-']
    let g:airline#extensions#tagbar#enabled = 0
    noremap <silent> <leader>2 :TagbarToggle<CR>
Plug 'corntrace/bufexplorer' " View the current buffers
    noremap <silent> <leader>3 :BufExplorer<CR>
    let g:bufExplorerDefaultHelp=0
" NOTE: Had to switch to a fork of gundo after some long-running bugs remained
" unresolved, breaking the plugin entirely.
Plug 'simnalamburt/vim-mundo' " View the undo/redo tree in a graphical format
    nnoremap <silent> <leader>4 :MundoToggle<CR>
    let g:mundo_right = 1
    let g:mundo_help  = 0


"" Filetype Specific Support
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'nvie/vim-flake8'
Plug 'moll/vim-node'
Plug 'kchmck/vim-coffee-script'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'prettier/vim-prettier'
Plug 'kergoth/vim-bitbake'
Plug 'evanleck/vim-svelte'
    let g:svelte_preprocessors = ['typescript']

"" Miscellaneous Plugs
Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
" Disabling these plugins for now due to performance issues
" Plug 'psliwka/vim-smoothie'
" Plug 'vimwiki/vimwiki'
" let g:vimwiki_list = [{'syntax': 'markdown'}]

" Autocomplete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'rcarriga/cmp-dap'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'ray-x/lsp_signature.nvim'
Plug 'folke/neodev.nvim'

" Fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
nnoremap <leader>fg <cmd>FzfLua live_grep<cr>
nnoremap <leader>fd <cmd>FzfLua diagnostics_workspace<cr>

" Markdown table alignment
Plug 'junegunn/vim-easy-align'

" Telescope for file searching
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
    " Find files using Telescope command-line sugar.
    " nnoremap <leader>ff <cmd>Telescope find_files<cr>
    " nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    " nnoremap <leader>fb <cmd>Telescope buffers<cr>
    " nnoremap <leader>fh <cmd>Telescope help_tags<cr>
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'psf/black', { 'branch': 'stable' }
Plug 'fisadev/vim-isort'

Plug 'sainnhe/everforest'
    let g:everforest_background = 'hard'

    " For better performance
    let g:everforest_better_performance = 1

Plug 'NLKNguyen/papercolor-theme'

Plug 'nvim-orgmode/orgmode', { 'branch': 'reece/clock-fixes' }
Plug 'chipsenkbeil/org-roam.nvim'

Plug 'github/copilot.vim'
let g:copilot_node_command = "~/.nodenv/versions/20.11.0/bin/node"
" Tab mapping has been reset to <C-g> to prevent conflicts with autocomplete
let g:copilot_no_tab_map = v:true
imap <expr> <Plug>(vimrc:copilot-dummy-map) copilot#Accept("\<Tab>")
let g:copilot_filetypes = {
    \ 'dap-repl': v:false,
\ }

Plug 'CopilotC-Nvim/CopilotChat.nvim'

" Avante setup (cursor-like LLM integration)
Plug 'stevearc/dressing.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'HakonHarnes/img-clip.nvim'
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make' }

Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'
Plug 'mfussenegger/nvim-dap-python'
Plug 'David-Kunz/jester'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'jbyuki/one-small-step-for-vimkind'

Plug 'pwntester/octo.nvim'
Plug 'petertriho/cmp-git'
Plug 'nvim-tree/nvim-web-devicons'

Plug 'samjwill/nvim-unception'
let g:unception_open_buffer_in_new_tab = v:true

Plug 'ReeceStevens/vim-reviewer'
Plug 'j-hui/fidget.nvim'

Plug 'ii14/neorepl.nvim'
" Note: Disabling headlines as it causes significant performance issues
" when editing large org files
" Plug 'lukas-reineke/headlines.nvim'

Plug 'stevearc/profile.nvim'

call plug#end()

lua << EOF

-- Telescope config
require('telescope').load_extension('fzf')

-- LSP progress reports
require("fidget").setup()

-- Treesitter config
-- This is currently disabled to streamline performance.
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = {'org', 'orgagenda', 'markdown'},              -- false will disable the whole extension
    -- I am running into a bug with treesitter causing a freeze editing TSX files, so disabling highlighting there for now.
    disable = { "c", "rust", "python", "tsx", "typescript", "yaml", "toml", "typescript.tsx", "typescriptreact", "gitcommit" },  -- list of language that will be disabled
    -- Required for spellcheck, some LaTex highlights and
    -- code block highlights that do not have ts grammar
    additional_vim_regex_highlighting = {'org'},
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require'octo'.setup({
  suppress_missing_scope = {
    projects_v2 = true,
  }
})
vim.api.nvim_set_keymap('n', '<leader>gi', ':Octo issue search<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gI', ':Octo issue create<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gp', ':Octo pr search<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gc', ':Octo comment add<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gla', ':Octo label add<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>glr', ':Octo label remove<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gb', ':Octo issue browser<CR>', { noremap = true, silent = true })


require'nvim-web-devicons'.setup{
default = true;
}

require'CopilotChat'.setup({
    show_help = "yes",
    prompts = {
        Explain = "Explain how it works.",
        Review = "Review the following code and provide concise suggestions.",
        Tests = "Briefly explain how the selected code works, then generate unit tests.",
        Refactor = "Refactor the code to improve clarity and readability.",
    },
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    event = "VeryLazy",
})

require('img-clip').setup({
    default = {
      embed_image_as_base64 = false,
      prompt_for_file_name = false,
      drag_and_drop = {
        insert_mode = true,
      },
      use_absolute_path = true,
    },
})
-- Only use render-markdown for Avante buffers, not markdown buffers.
-- The highlights are useful for Avante but make general markdown buffers
-- too visually noisy.
require('render-markdown').setup({
    file_types = {'Avante'},
})
require('avante_lib').load()
require('avante').setup()


-- Configure profiler for performance monitoring, if enabled with env var
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

local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
  require("profile").instrument_autocmds()
  if should_profile:lower():match("^start") then
    require("profile").start("*")
  else
    require("profile").instrument("*")
  end
  vim.keymap.set("", "<f1>", toggle_profile)
end

EOF

" Copilot Chat default keybindings
nnoremap <leader>ccb <cmd>CopilotChatBuffer<cr>
nnoremap <leader>cce <cmd>CopilotChatExplain<cr>
nnoremap <leader>cct <cmd>CopilotChatTests<cr>
xnoremap <leader>ccv :CopilotChatVisual<cr>
xnoremap <leader>ccx :CopilotChatInPlace<cr>
