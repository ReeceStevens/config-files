" NOTE: This is a config for 'vanilla' vim. See neovim configuration for the
" one in active use.
" Typing preferences and asthetics
colo molokai
set tabstop=4
set shiftwidth=4
set softtabstop=4
set number
set rnu
set backspace=2
syntax on
set mouse=a
set background=dark

set ignorecase
set smartcase
set scrolloff=5
set expandtab
set cursorline
set list " show whitespace
set clipboard+=unnamedplus " neovim clipboard setting
set diffopt=vertical       " Open vimdiffs in vertical splits
let mapleader=","
set tags+=.git/tags

set laststatus=2
set encoding=utf-8

" Allow project-specific vimrc configuration
set secure exrc

" Switch colon and semicolon
nnoremap ; :
vnoremap ; :
nnoremap : ;
vnoremap : ;

" Move around long lines as break lines
nnoremap j gj
nnoremap k gk

" Remap ESC to jk in quick succession
inoremap jk <ESC>
inoremap <ESC> <nop>

" Remap number incrementing to not conflict with tmux binding
nnoremap <C-b> <C-a>

" For finger fumbling (thanks pato)
command! W w
command! Wq wq
command! WQ wq
command! Q q
command! Wa wa
command! WA wa

nnoremap <leader>c :terminal<CR>
nnoremap <leader>z :tabe %<CR>

" Easier terminal exit
tnoremap <C-w>h <C-\><C-N><C-w>h
tnoremap <C-w>j <C-\><C-N><C-w>j
tnoremap <C-w>k <C-\><C-N><C-w>k
tnoremap <C-w>l <C-\><C-N><C-w>l

" Easy access to location/quickfix lists
function! QuickfixListIsOpen()
    return getqflist({'winid': 1}).winid != 0
endfunction

function! QuickfixListToggle()
    if QuickfixListIsOpen()
        cclose
    else
        copen
    endif
endfunction

nnoremap <leader>e :lopen<CR>
nnoremap <leader>q :call QuickfixListToggle()<CR>

" Remap FZF to ctrl-p
nnoremap <C-p> :FZF<CR>

" Turn relative number on when scrolling
" and off while typing
autocmd InsertEnter * :set rnu!
autocmd InsertLeave * :set rnu


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
    noremap <silent> <leader>5 :Gblame<CR>
Plug 'tpope/vim-rhubarb' " github Gbrowse support
Plug 'tommcdo/vim-fubitive' " bitbucket Gbrowse support
Plug 'airblade/vim-gitgutter'
    let g:gitgutter_sign_added = '+'
    let g:gitgutter_sign_modified = '∙'
    let g:gitgutter_sign_removed = '-'
    let g:gitgutter_sign_modified_removed = '∙'
Plug 'tpope/vim-commentary'
Plug 'majutsushi/tagbar' " Show the ctags in a file
    let g:tagbar_iconchars = ['+', '-']
    let g:airline#extensions#tagbar#enabled = 0
    noremap <silent> <leader>2 :TagbarToggle<CR>

Plug 'corntrace/bufexplorer' " View the current buffers
    noremap <silent> <leader>3 :BufExplorer<CR>
    let g:bufExplorerDefaultHelp=0
Plug 'sjl/gundo.vim' " View the undo/redo tree in a graphical format
    nnoremap <silent> <leader>4 :GundoToggle<CR>
    let g:gundo_right = 1
    let g:gundo_help  = 0


"" Autocomplete
" The all-powerful completion engine
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --go-completer --ts-completer --rust-completer --cs-completer' }
    let g:ycm_auto_trigger=1
    let g:ycm_autoclose_preview_window_after_completion=1
    if !exists("g:ycm_semantic_triggers")
      let g:ycm_semantic_triggers = {}
    endif
    let g:ycm_semantic_triggers['typescript'] = ['.']

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

Plug 'junegunn/fzf.vim'

Plug 'Shougo/vimproc.vim'
Plug 'eagletmt/neco-ghc'

"" Syntax Checking
Plug 'neomake/neomake'
    let g:neomake_check_on_open = 1
    let g:neomake_check_on_wq = 0
    let g:neomake_rust_enabled_makers = ['cargo']
    let g:neomake_python_enabled_makers = ['pylint']
    let g:neomake_javascript_enabled_makers = ['eslint']
    let g:neomake_typescript_enabled_makers = ['tsc', 'tslint']
    " let g:neomake_typescript_enabled_makers = ['tsc']
    let g:neomake_haskell_enabled_makers = ['ghc-mod', 'hlint']
    let g:neomake_cpp_enabled_makers = []
    let g:neomake_java_enabled_makers = []
    let g:neomake_stl_format = '[%E{Err: %e}%B{, }%W{Warn: %w}]'

     " let g:neomake_error_sign = {'text': 'E>', 'texthl': 'NeomakeErrorSign'}
     let g:neomake_error_sign = {'text': 'E>', 'texthl': 'NeomakeMessageSign'}
     let g:neomake_warning_sign = {
         \   'text': 'W>',
         \   'texthl': 'NeomakeWarningSign',
         \ }
     let g:neomake_message_sign = {
          \   'text': 'M>',
          \   'texthl': 'NeomakeMessageSign',
          \ }
     let g:neomake_note_sign = {'text': 'I>', 'texthl': 'NeomakeInfoSign'}
     let g:neomake_info_sign = {'text': 'I>', 'texthl': 'NeomakeInfoSign'}
     let g:neomake_highlight_columns = 5


"" Filetype Specific Support
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'nvie/vim-flake8'
Plug 'moll/vim-node'
Plug 'kchmck/vim-coffee-script'
Plug 'mxw/vim-jsx'
    let g:jsx_ext_required = 0
Plug 'eagletmt/ghcmod-vim'
Plug 'prettier/vim-prettier'
Plug 'kergoth/vim-bitbake'

"" Miscellaneous Plugs
Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
" Plug 'psliwka/vim-smoothie'
" Plug 'vimwiki/vimwiki'
" let g:vimwiki_list = [{'syntax': 'markdown'}]
call plug#end()

let g:color_scheme = "dark"
function! ToggleColors()
    if g:color_scheme == "dark"
        let g:airline_theme='tomorrow'
        colo Tomorrow
        let g:color_scheme = "light"
    else
        let g:airline_theme='badwolf'
        colo molokai
        let g:color_scheme = "dark"
    endif
endfunction

noremap <leader>li :call ToggleColors()<CR>

let g:ycm_python_binary_path = 'python'
let g:python_host_prog = '/usr/bin/python' " Virtualenv workaround
let g:python3_host_prog = '/usr/bin/python'
let g:ycm_server_python_interpreter = '/usr/bin/python'

" Completion and Syntax Checking Options
"" YCM preferences
noremap <leader>d :YcmCompleter GetDoc<CR>
" noremap <leader>D <plug>(YCMHover)
noremap <leader>D :YcmCompleter GoToDefinition<CR>
noremap <leader>t :YcmCompleter GetType<CR>
noremap <leader>f :YcmCompleter FixIt<CR>
noremap <leader>r :YcmCompleter RefactorRename

" coc-nvim preferences
" nmap <silent> <leader>d :call CocAction('doHover')<CR>
" nnoremap <silent> <leader>d :call <SID>show_documentation()<CR>
" nmap <silent> <leader>D <Plug>(coc-definition)
" nmap <silent> <leader>t <Plug>(coc-type-definition)
" nmap <silent> <leader>r <Plug>(coc-rename)
" nmap <silent> <leader>R <Plug>(coc-references)
" nmap <silent> <leader>f <Plug>(coc-fix-current)
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)
" nmap <leader>g  :CocDiagnostics<CR>

"" Run syntax checkers after every file save
autocmd BufWritePost * Neomake

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction

" Filetype Specific Settings
function! JavaOptions()
    nnoremap <leader>d :JavaDocPreview<CR>
    nnoremap <leader>i :JavaImport<CR>
    nnoremap <leader>I :JavaImportOrganize<CR>
endfunction
let g:EclimCompletionMethod = 'omnifunc'

function! LatexOptions()
    setlocal spell
    command! Latex execute "silent !pdflatex % > /dev/null && evince %:r.pdf > /dev/null 2>&1 &" | redraw!
    nnoremap <F2> :Latex<CR>
    command! Pandoc execute "silent !pandoc --out=%:r.pdf % > /dev/null && evince %:r.pdf > /dev/null 2>&1 &" | redraw!
    command! PandocSlides execute "silent !pandoc --to=beamer --out=%:r.pdf % > /dev/null && evince %:r.pdf > /dev/null 2>&1 &" | redraw!
    nnoremap <F2> :Pandoc<CR>
    nnoremap <F3> :PandocSlides<CR>
endfunction

function! MarkdownOptions()
    set filetype=markdown
    syn region math start=/\$\$/ end=/\$\$/
    syn match math '\$[^$].\{-}\$'
    hi link math Statement
    let g:markdown_fenced_languages = ["c","rust","python","html","matlab","java","typescript"]
    command! Pandoc execute "silent !pandoc --to=Latex --out=%:r.pdf % > /dev/null && evince %:r.pdf > /dev/null 2>&1 &" | redraw!
    command! PandocSlides execute "silent !pandoc --to=beamer --out=%:r.pdf % > /dev/null && evince %:r.pdf > /dev/null 2>&1 &" | redraw!
    nnoremap <F2> :Pandoc<CR>
    nnoremap <F3> :PandocSlides<CR>
endfunction

function! RustOptions()
    nnoremap <buffer> <F9> :RustRun<cr>
endfunction

function! PythonOptions()
    " Run python scripts by pressing <F9>
    nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>
endfunction

function! HaskellOptions()
    let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
    let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
    let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
    let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
    let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
    let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
    let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
endfunction

function! TypescriptOptions()
    " Disable since we have Neomake checking
    let g:ycm_show_diagnostics_ui = 0
endfunction

au FileType java call JavaOptions()
au FileType python call PythonOptions()
au FileType gitcommit setlocal tw=72
au FileType rust call RustOptions()
au FileType typescript call TypescriptOptions()
au FileType typescript.tsx call TypescriptOptions()
au BufNewFile,BufRead,BufFilePre *.tex call LatexOptions()
au BufNewFile,BufFilePre,BufRead *.md call MarkdownOptions()
au BufNewFile,BufFilePre,BufRead *.tsx set filetype=typescript.tsx
au BufNewFile,BufFilePre,BufRead *.jsx set filetype=javascript.jsx
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
au BufNewFile,BufFilePre,BufRead *.hs setlocal omnifunc=necoghc#omnifunc
au BufNewFile,BufFilePre,BufRead Jenkinsfile set filetype=groovy
