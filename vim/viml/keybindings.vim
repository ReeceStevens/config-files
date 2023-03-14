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

" easier terminal access
nnoremap <leader>c :terminal<CR>
" zoom current pane into its own tab
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

" Git shortcuts
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git log<CR>
vnoremap <leader>gcl :Gclog <CR>

" Flip between light or dark theme with `,li`
let g:color_scheme = "dark"
function! ToggleColors()
    if g:color_scheme == "dark"
        let g:airline_theme='tomorrow'
        " colo solarized8_light_high
        set background=light
        colo everforest
        let g:color_scheme = "solarized"
    else
        let g:airline_theme='badwolf'
        set background=dark
        colo molokai
        let g:color_scheme = "dark"
    endif
endfunction

noremap <leader>li :call ToggleColors()<CR>

nnoremap <leader>cp :Copilot enable<CR>
nnoremap <leader>cpd :Copilot disable<CR>

