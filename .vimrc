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
set scrolloff=5
set expandtab
set cursorline
set list
set clipboard+=unnamedplus " neovim clipboard setting
set diffopt=vertical       " Open vimdiffs in vertical splits
let mapleader=","

set laststatus=2
set encoding=utf-8

filetype off
set rtp^=~/.config/nvim/bundle/Vundle.vim
call vundle#begin()
" General Plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'L9'                         " Extend Vim's default scripts
Plugin 'ctrlpvim/ctrlp.vim'         " Enable fuzzy searching
    " Ignore files listed in the .gitignore
    let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
Plugin 'flazz/vim-colorschemes'     " Enable more colorschemes by default
Plugin 'Valloric/YouCompleteMe'     " The all-powerful completion engine
    let g:ycm_autoclose_preview_window_after_completion=1
    " map <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
" Plugin 'scrooloose/syntastic' "Handle syntax support and PEP8 compliance
    " let g:syntastic_stl_format = '[%E{Err: %e}%B{, }%W{Warn: %w}]'
Plugin 'haya14busa/vim-easymotion'  " Double-leader for suggested jumps instead of numbers
Plugin 'tpope/vim-unimpaired'       " Convenient mappings for the quickfix list
Plugin 'tpope/vim-fugitive'         " The all-powerful git plugin
Plugin 'vim-airline/vim-airline'    " Statusline
    let g:airline_powerline_fonts = 1
    let g:airline_skip_empty_sections = 1
    let g:airline_theme='badwolf'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#virtualenv#enabled = 1
    let g:airline#extensions#whitespace#enabled = 0
    let g:airline_section_y = '' " Disable file encoding section
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-commentary'
Plugin 'scrooloose/nerdtree' " Show the current working directory in a nice tree
    noremap <silent> <leader>1 :NERDTreeToggle<CR>
    let NERDTreeIgnore = ['\~$', '\.pyc', '__pycache__']
    let NERDTreeMapHelp = '<f1>'
Plugin 'majutsushi/tagbar.git' " Show the ctags in a file
    let g:tagbar_iconchars = ['+', '-']
    let g:airline#extensions#tagbar#enabled = 0
    noremap <silent> <leader>2 :TagbarToggle<CR>
Plugin 'corntrace/bufexplorer' " View the current buffers
    noremap <silent> <leader>3 :BufExplorer<CR>
    let g:bufExplorerDefaultHelp=0
Plugin 'sjl/gundo.vim.git' " View the undo/redo tree in a graphical format
    nnoremap <silent> <leader>4 :GundoToggle<CR>
    let g:gundo_right = 1
    let g:gundo_help  = 0
Plugin 'vimwiki/vimwiki'

" Filetype-specific plugins
Plugin 'leafgarland/typescript-vim' " TypeScript syntax highlighting
    if !exists("g:ycm_semantic_triggers")
      let g:ycm_semantic_triggers = {}
    endif
    let g:ycm_semantic_triggers['typescript'] = ['.']
    let g:syntastic_typescript_tsc_fname = ''
Plugin 'jmcantrell/vim-virtualenv'  " Handle virtualenv gracefully
    let g:virtualenv_directory = '/Users/reecestevens/innolitics/dicom-standard-browser/'
Plugin 'nvie/vim-flake8'
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_python_checkers = ['mypy', 'pylint']
    let g:syntastic_javascript_checkers = ['eslint']
Plugin 'mxw/vim-jsx' " JSX Syntax Highlighting
    let g:jsx_ext_required = 0
Plugin 'moll/vim-node' " Node.js Tools
Plugin 'rust-lang/rust.vim'
Plugin 'ternjs/tern_for_vim'
let g:tern#filetypes = [
    \ 'jsx',
    \ 'javascript.jsx'
    \ ]
" Plugin 'neovimhaskell/haskell-vim' " Haskell Syntax Highlighting

Plugin 'eagletmt/ghcmod-vim'
Plugin 'eagletmt/neco-ghc'
Plugin 'Shougo/vimproc.vim'
    " Haskell syntax options
    let g:syntastic_haskell_checkers = ['ghc-mod', 'hlint']
    let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
    let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
    let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
    let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
    let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
    let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
    let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

Plugin 'neomake/neomake'
    let g:neomake_check_on_open = 1
    let g:neomake_check_on_wq = 0
    "let g:neomake_python_enabled_makers = ['pylint']
    let g:neomake_python_enabled_makers = ['mypy']
    let g:neomake_javascript_enabled_makers = ['eslint']
    let g:neomake_rust_enabled_makers = ['cargo']
    " This required editing the rust.vim file inside Neomake
    " and adding the cargo maker. This might break on update.
    let g:neomake_haskell_enabled_makers = ['ghc-mod', 'hlint']
    let g:neomake_cpp_enabled_makers = []
    let g:neomake_java_enabled_makers = []
    let g:neomake_stl_format = '[%E{Err: %e}%B{, }%W{Warn: %w}]'

Plugin 'racer-rust/vim-racer'
    let g:racer_cmd = '~/.cargo/bin/racer'

call vundle#end()
filetype plugin indent on

" Run checkers after every file save
autocmd BufWritePost * Neomake

" YCM preferences
let g:python_host_prog = '/usr/bin/python' " Virtualenv workaround
let g:ycm_python_binary_path = '/usr/bin/python'
let g:ycm_server_python_interpreter = '/usr/bin/python'

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

" For finger fumbling (thanks pato)
command! W w
command! Wq wq
command! WQ wq
command! Q q
command! Wa wa
command! WA wa

nnoremap <leader>c :terminal<CR>

noremap <leader>d :YcmCompleter GetDoc<CR>
noremap <leader>t :YcmCompleter GetType<CR>

" Eclim Settings
function! JavaKeybindings()
    nnoremap <leader>d :JavaDocPreview<CR>
    nnoremap <leader>i :JavaImport<CR>
    nnoremap <leader>I :JavaImportOrganize<CR>
endfunction

let g:EclimCompletionMethod = 'omnifunc'
au FileType java call JavaKeybindings()


" Turn relative number on when scrolling
" and off while typing
autocmd InsertEnter * :set rnu!
autocmd InsertLeave * :set rnu

"" Filetype Specific Settings

"" GITCOMMIT Options
au FileType gitcommit setlocal tw=72

"" Python Options
autocmd FileType *.py set expandtab
autocmd Filetype *.py setlocal tw=79 "" For PEP8 compliance

autocmd Filetype *.js set expandtab
autocmd BufNewFile,BufFilePre,BufRead *.tsx set filetype=typescript

" Compile and run python files by pressing <F9>
nnoremap <buffer> <F9> :exec '!python3' shellescape(@%, 1)<cr>

" Compile Latex documents (Mac version, opens in Preview)
command Latex execute "silent !pdflatex % > /dev/null && evince %:r.pdf > /dev/null 2>&1 &" | redraw!

command Pandoc execute "silent !pandoc --to=Latex --out=%:r.pdf % > /dev/null && evince %:r.pdf > /dev/null 2>&1 &" | redraw!

command MakeSlides execute "silent !make && mupdf slides.pdf" | redraw!
nnoremap <F4> :MakeSlides<CR>

au BufNewFile,BufFilePre,BufRead Jenkinsfile set filetype=groovy

"" Latex Options
autocmd BufNewFile,BufRead,BufFilePre *.tex set spell
autocmd FileType *.tex setlocal nocursorline
autocmd BufNewFile,BufRead,BufFilePre *.tex nnoremap <F2> :Latex<CR>

"" Markdown Options
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

function! MarkdownOptions()
    syn region math start=/\$\$/ end=/\$\$/
    syn match math '\$[^$].\{-}\$'
    hi link math Statement
    let g:markdown_fenced_languages = ['c','python','html','matlab', 'java']
    nnoremap <F2> :Pandoc<CR>
endfunction

autocmd BufNewFile,BufFilePre,BufRead *.md call MarkdownOptions()

autocmd BufNewFile,BufFilePre,BufRead *.hs setlocal omnifunc=necoghc#omnifunc

