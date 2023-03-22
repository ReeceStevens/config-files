" Filetype Specific Settings

function! JavaOptions()
    nnoremap <leader>d :JavaDocPreview<CR>
    nnoremap <leader>i :JavaImport<CR>
    nnoremap <leader>I :JavaImportOrganize<CR>
endfunction
let g:EclimCompletionMethod = 'omnifunc'

function! LatexOptions()
    setlocal spell
    command! Latex execute "silent !pdflatex % > /dev/null && open %:r.pdf > /dev/null 2>&1 &" | redraw!
    nnoremap <F2> :Latex<CR>
    command! Pandoc execute "silent !pandoc --out=%:r.pdf % > /dev/null && open %:r.pdf > /dev/null 2>&1 &" | redraw!
    command! PandocSlides execute "silent !pandoc --to=beamer --out=%:r.pdf % > /dev/null && open %:r.pdf > /dev/null 2>&1 &" | redraw!
    nnoremap <F2> :Pandoc<CR>
    nnoremap <F3> :PandocSlides<CR>
endfunction

function! MarkdownOptions()
    set filetype=markdown
    syn region math start=/\$\$/ end=/\$\$/
    syn match math '\$[^$].\{-}\$'
    hi link math Statement
    " let g:markdown_fenced_languages = ["c","rust","python","html","matlab","java","typescript"]
    " let g:vim_markdown_fenced_languages = ["c","rust","python","html","matlab","java","typescript"]
    " command! Pandoc execute "silent !pandoc --to=Latex --out=%:r.pdf % > /dev/null && open %:r.pdf > /dev/null 2>&1 &" | redraw!
    command! Pandoc execute "silent !pandoc --out=%:r.pdf % > /dev/null && open %:r.pdf > /dev/null 2>&1 &" | redraw!
    command! PandocSlides execute "silent !pandoc --to=beamer --out=%:r.pdf % > /dev/null && open %:r.pdf > /dev/null 2>&1 &" | redraw!
    nnoremap <F2> :Pandoc<CR>
    nnoremap <F3> :PandocSlides<CR>
    " Align markdown tables
    vnoremap <Leader><Bslash> :EasyAlign*<Bar><Enter>
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

au FileType java call JavaOptions()
au FileType python call PythonOptions()
au FileType gitcommit setlocal tw=72
au FileType rust call RustOptions()
au FileType terraform set filetype=hcl
" Disabled since this causes major performance degredation editing markdown
" au FileType markdown setlocal foldlevel=99
au BufNewFile,BufRead,BufFilePre *.tex call LatexOptions()
au BufNewFile,BufFilePre,BufRead *.md call MarkdownOptions()
au BufNewFile,BufFilePre,BufRead *.tsx set filetype=typescript.tsx
au BufNewFile,BufFilePre,BufRead *.jsx set filetype=javascript.jsx
au BufNewFile,BufFilePre,BufRead *.hs setlocal omnifunc=necoghc#omnifunc
au BufNewFile,BufFilePre,BufRead Jenkinsfile set filetype=groovy
