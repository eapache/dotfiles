"""""""""""""""""""""""""""""""""""""""""""""""""""""
" SETUP PLUG
"""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()
Plug 'eapache/auto-pairs'
Plug 'Konfekt/FastFold'
Plug 'luochen1990/rainbow'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'airblade/vim-gitgutter'
Plug 'dbakker/vim-projectroot'
Plug 'zhimsel/vim-stay'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
Plug 'neomake/neomake'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASE
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible " drop kludgy hacks needed to claim offical 'vi' compatibility
set virtualedit=all " allow the cursor to move freely outside of existing chars
set visualbell " flash instead of beeping when you eg hit the screen edge
set hidden " allow unsaved changes to exist in background buffers
set backspace=indent,eol,start " make the backspace key work like you'd expect
set background=dark " Dark themes are more readable with this
set t_Co=256 " Enable 256 colour mode
set formatoptions=bjt " See :help fo-table

set title
set wildmenu
set wildmode=list:longest

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" SYNTAX, FILE-TYPES, AND LINTERS
"""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
filetype on
filetype plugin on
filetype indent on
set synmaxcol=256

au BufRead,BufNewFile Capfile set filetype=ruby

let g:vim_json_syntax_conceal = 0 " Don't hide json quotes

call neomake#configure#automake('rw', 1000)

let g:ragel_default_subtype='ruby'
let g:neomake_warning_sign = { 'text': 'W', 'texthl': 'WarningMsg' }
let g:neomake_error_sign = { 'text': 'E', 'texthl': 'ErrorMsg' }
let g:neomake_ruby_enabled_makers = ['mri', 'rubocop']
let g:neomake_ruby_rubocop_exe = 'bundle'
let g:neomake_ruby_rubocop_args = ['exec', 'rubocop','--format', 'emacs', '--force-exclusion', '--display-cop-names']

highlight WarningMsg ctermbg=yellow ctermfg=black
highlight link NeomakeError ErrorMsg
highlight link NeomakeWarning WarningMsg

" Sorbet
autocmd FileType ruby syn match sorbetSignature "\<sig\>" nextgroup=sorbetSignatureDeclaration skipwhite skipnl
autocmd FileType ruby syn region sorbetSignatureBlock start="sig {" end="}"
autocmd FileType ruby syn region sorbetSignatureBlock start="\<sig\> \<do\>" matchgroup=sorbetSignature end="\<end\>"
autocmd FileType ruby hi def link sorbetSignature Comment
autocmd FileType ruby hi def link sorbetSignatureBlock Comment

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" WHITESPACE AND LINE-WIDTH
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set wrap
set textwidth=80
set colorcolumn=81
au FileType java,go setlocal textwidth=0 colorcolumn=0
au FileType ruby,erb,eruby,coffee setlocal textwidth=120 colorcolumn=120
highlight ColorColumn ctermbg=grey ctermfg=black

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" FOLDING AND INDENTATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldmethod=syntax
set foldnestmax=2
set foldminlines=2

set autoindent    " automatically indent new lines
set softtabstop=4 " column multiple to use when hitting 'tab' in insert mode
set shiftwidth=4  " Indent width for autoindent
set tabstop=8     " Display tabs as x characters wide
set expandtab     " Set tabs to automatically expand into spaces

au FileType c,cpp,go setlocal foldnestmax=1
au FileType lua,ruby,eruby,vim,yaml,coffee,javascript setlocal shiftwidth=2 softtabstop=2
au FileType java,go,swift setlocal shiftwidth=8 softtabstop=8 noexpandtab
au FileType diff setlocal foldnestmax=0
au FileType json setlocal foldnestmax=4

" Set the initial fold level to one less than the total available folds
au BufRead,BufNewFile * let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))-1

" Searches for a def and (assuming two-space indents) sets the right fold level
function RubyFolding()
  setlocal foldmethod=indent foldignore= " ruby syntax folding is deadly slow
  call cursor(1, 1)
  let lineno = search("^\\s*def ")
  if lineno ># 0
    call cursor(1, 1)
    let &foldnestmax = 1 + (indent(lineno) / 2)
  endif
endfunction
au FileType ruby call RubyFolding()

" Searches for a global 'extern C' and adjusts the fold level
function CppFolding()
  call cursor(1, 1)
  let lineno = search("^extern \"C\"")
  if lineno ># 0
    call cursor(1, 1)
    set foldnestmax=2
  endif
endfunction
au FileType cpp call CppFolding()

" Don't update folds on every open/close to keep them snappy
let g:fastfold_fold_command_suffixes = []

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" PARENTHESES AND MATCHING
"""""""""""""""""""""""""""""""""""""""""""""""""""""
let loaded_matchparen = 1 " disable live flashing matcher plugin
runtime macros/matchit.vim " Extends % to match more and smarter

" Rainbow parentheses
let g:rainbow_active = 1
let g:rainbow_conf =
      \ {
      \   'separately': {
      \     'fugitiveblame': 0,
      \   }
      \ }

" Auto-Pairs takes some configuring
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutJump = ''
let g:AutoPairsCenterLine = 0
let g:AutoPairsMultilineClose = 0
let g:AutoPairsOnlyWhitespace = 1
let g:AutoPairsUseInsertedCount = 1
let g:AutoPairsDelRepeatedPairs = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" SEARCHING AND COMPLETION
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase " make searches case-insensitive by default
set incsearch  " search as you type
set nohlsearch " don't highlight searches
set smartcase  " don't ignore case for explicit caps
set completeopt=menu,longest

" Integrate YouCompleteMe with vim-multiple-cursors, otherwise
" the numerous Cursor events cause great slowness
" (https://github.com/kristijanhusak/vim-multiple-cursors/issues/4)
function! Multiple_cursors_before()
  let s:old_ycm_whitelist = g:ycm_filetype_whitelist
  let g:ycm_filetype_whitelist = {}
endfunction

function! Multiple_cursors_after()
  let g:ycm_filetype_whitelist = s:old_ycm_whitelist
endfunction

" other YouCompleteMe options
let g:ycm_min_num_of_chars_for_completion = 3
let g:ycm_show_diagnostics_ui = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC PLUGIN TWEAKS
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set cscopetag
set cscopetagorder=1
au BufEnter * set tags+=./tags;
let root = projectroot#guess()
if root == getcwd()
  silent! cscope add cscope.out
else
  " only do this if we have to, otherwise we don't get the pretty relative paths
  silent! !exe "cscope add " . root . '/cscope.out ' . root
endif

let g:go_fmt_fail_silently = 1     " ignore auto-fmt failures
let g:go_fmt_command = "goimports" " use goimports for auto-fmt

let g:EasyMotion_startofline = 0 " keep cursor column when J/K motion
let g:EasyMotion_smartcase = 1

let g:multi_cursor_exit_from_insert_mode=0
let g:multi_cursor_quit_key='q'
let g:multi_cursor_insert_maps={'\':1, 'j':1, 'J':1}

let g:airline_left_sep=''
let g:airline_right_sep=''
set laststatus=2

set rtp+=/usr/local/opt/fzf
nnoremap <c-b> :Buffers<CR>
nnoremap <c-p> :GFiles -- . ':!:*.rbi'<CR>
let g:fzf_preview_window = ['down:40%', 'ctrl-/']

" disable netrw, I don't want it and it's super-slow on large files
let loaded_netrwPlugin = 1

" vim-stay recommends this
set viewoptions-=options

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM KEY MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap jk <esc>
inoremap Jk <esc>
inoremap JK <esc>

" cscope shortcuts
nnoremap <Leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>d :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <Leader>i :cs find i <C-R>=expand("<cfile>")<CR><CR>

" EasyMotion (can't use 'nore' because these are <Plug>s)
nmap <Leader>j <Plug>(easymotion-j)
nmap <Leader>k <Plug>(easymotion-k)
nmap <Leader>w <Plug>(easymotion-w)
nmap <Leader>b <Plug>(easymotion-b)
nmap f <Plug>(easymotion-s)
nmap F <Plug>(easymotion-s2)

" Syntastic/Neomake Errors (via vim's location list)
nnoremap ]e :lnext<CR>
nnoremap [e :lprev<CR>
nnoremap <Leader>e :lfirst<CR>

let g:splitjoin_split_mapping = 'gs'
let g:splitjoin_join_mapping = 'gj'

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" HANDLE LARGE FILES
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function CheckFileSize()
  let f=getfsize(expand("<afile>"))
  if f < 1024 * 1024 " 1 MB seems a good threshold
    return
  endif

  set foldmethod=manual " disable folding
  syntax off " disable syntax
endfunction
au BufReadPre * call CheckFileSize()

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" FINALLY
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set secure
