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

" Markdown table alignment
Plug 'junegunn/vim-easy-align'

" Telescope for file searching
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
    " Find files using Telescope command-line sugar.
    " nnoremap <leader>ff <cmd>Telescope find_files<cr>
    nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    " nnoremap <leader>fb <cmd>Telescope buffers<cr>
    " nnoremap <leader>fh <cmd>Telescope help_tags<cr>
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'psf/black', { 'branch': 'stable' }
Plug 'fisadev/vim-isort'

Plug 'sainnhe/everforest'
Plug 'NLKNguyen/papercolor-theme'

Plug 'nvim-orgmode/orgmode'

Plug 'github/copilot.vim'
let g:copilot_node_command = "~/.nodenv/versions/16.18.0/bin/node"
" Tab mapping has been reset to <C-g> to prevent conflicts with autocomplete
let g:copilot_no_tab_map = v:true
imap <expr> <Plug>(vimrc:copilot-dummy-map) copilot#Accept("\<Tab>")

Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'mfussenegger/nvim-dap-python'
" Plug 'theHamsta/nvim-dap-virtual-text'

Plug 'pwntester/octo.nvim'
Plug 'petertriho/cmp-git'

Plug 'ReeceStevens/vim-reviewer'

call plug#end()

lua << EOF

-- Telescope config
require('telescope').load_extension('fzf')

-- Treesitter config
-- This is currently disabled to streamline performance.
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = {'org', 'orgagenda'},              -- false will disable the whole extension
    -- I am running into a bug with treesitter causing a freeze editing TSX files, so disabling highlighting there for now.
    disable = { "c", "rust", "python", "tsx", "typescript", "yaml", "toml" },  -- list of language that will be disabled
    -- Required for spellcheck, some LaTex highlights and
    -- code block highlights that do not have ts grammar
    additional_vim_regex_highlighting = {'org'},
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require'octo'.setup()

EOF
