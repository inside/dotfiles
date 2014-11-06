" Variables initialization {{{
let mapleader = ","
" Disables match paren from the pi_paren standard plugin
let g:loaded_matchparen = 1
let g:last_active_tab = 1
" }}}

" User functions {{{
function! ToggleActiveMouse()
  if &mouse == "nv"
    set mouse=
    echo "Mouse is off"
  else
    set mouse=nv
    echo "Mouse is on"
  endif
endfunction

" This can conflict with the default mappings provided by snipmate.
" See the after directory in .vim/bundle/snipMate/after
function! SuperCleverTab()
  if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
    return "\<Tab>"
  elseif pumvisible()
    return "\<c-n>"
  else
    if &omnifunc != ''
      return "\<C-X>\<C-O>"
    elseif &dictionary != ''
      return "\<C-K>"
    else
      return "\<C-N>"
    endif
  endif
endfunction

" Go to next/previous SGML tag
" Credit goes to https://github.com/tejr/nextag/blob/master/plugin/nextag.vim
function! NextTag(direction)
  let ptn = '\m<\/\?\w\+[^>]*>'

  if a:direction == 'next'
    call search(ptn)
  elseif a:direction == 'previous'
    call search(ptn, 'b')
  endif
endfunction

nnoremap <silent> tn :call NextTag('next')<cr>
nnoremap <silent> tp :call NextTag('previous')<cr>
" }}}

" General options {{{

set nocompatible
set incsearch
set complete-=t " Don't look for tags when completing
set complete-=i " Don't look for included files
set termencoding=utf-8
set hidden
set lazyredraw  " Do not redraw while running macros (much faster)
set infercase   " Case sensitive insert completion even if ingorecase is set
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/backup " Stores swap files there
set writebackup
set ttymouse=xterm2 " Make mouse work on virtual terms like screen
set whichwrap=b,s,<,>
set wildignore+=*.git*
set history=200

" Disable setting options by file like /* vim: set sw=2: */
set nomodeline
set colorcolumn=80
" Use only 1 space after "." when joining lines instead of 2
set nojoinspaces
" Character to precede line wraps
" Using let instead of set to be able to use quotes
let &showbreak='↪ '
" Always show 3 lines above or below the cursor
set scrolloff=3
" }}}

" Visual options {{{
set showmatch
set nohlsearch
set ruler
" If 't_vb' is cleared and 'visualbell' is set, no beep and no flash will ever occur
set visualbell
set t_vb=
set wildmenu
set wildmode=list:longest,full
set guicursor+=a:blinkon0
set relativenumber
set list
let &listchars='tab:▸ '
" Don't colorize syntax after 512 characters
set synmaxcol=512
" For at least vim >= 7.4.338
if v:version > 704 || v:version == 704 && has('patch338')
  set breakindent
endif
" }}}

" Text formatting options {{{
" For clarity's sake use the same value for these 3 options.
" See http://vimcasts.org/episodes/tabs-and-spaces/ for a full explanation.
set shiftwidth=4 softtabstop=4 tabstop=4
" Inserts spaces instead of tabs.
" If you want to use tab characters, don't touch shiftwidth, softtabstop and
" tabstop, just set noexpandtab.
set expandtab
set backspace=indent,eol,start
set textwidth=0
set autoindent
set ignorecase
set smartcase
" }}}

" Vim UI options {{{
set laststatus=2
set showcmd
set showmode
set cursorline
" }}}

" Color options {{{
" See http://www.vim.org/tips/tip.php?tip_id=1312
" 256 colors may be needed for any other colorscheme except solarized
"set t_Co=256
" Needed for solarized: Use the 16 colors terminal option to get VIM to look
" like GVIM with solarized colors.
set t_Co=16
syntax on
set background=dark
" }}}

" Mappings {{{
set winaltkeys=no

" Get to know the current pattern count match
nnoremap <leader>o :%s///gn<cr>

" Quick way to recall macro a
nnoremap <leader>2 @a

" Quick way to recall last command
nnoremap <leader>3 @:

" Edit ~/.vimrc or ~/.zshrc
nnoremap <leader>E :edit $MYVIMRC<cr>
nnoremap <leader>Z :edit ~/.zshrc<cr>

" Source my vimrc
nnoremap <leader>S :source $MYVIMRC<cr>

" Toggle mouse on or off
nnoremap <leader><cr> :call ToggleActiveMouse()<cr>

" call the tagbar window
nnoremap tt :TagbarToggle<cr>

" Unite
nnoremap <silent> <leader>ff
      \ :<c-u>Unite
      \ -no-split -buffer-name=files -start-insert
      \ file_rec/async<cr>
nnoremap <silent> <leader>fb
      \ :<c-u>Unite
      \ -no-split -buffer-name=buffers -start-insert
      \ buffer<cr>
nnoremap <silent> <leader>fo
      \ :<c-u>Unite
      \ -no-split -buffer-name=outline -start-insert
      \ outline<cr>
nnoremap <silent> <leader>fl
      \ :<c-u>Unite
      \ -no-split -buffer-name=lines -start-insert
      \ line<cr>

" save file whether in insert or normal mode
inoremap <leader>s <c-o>:w<cr><esc>
nnoremap <leader>s :w<cr>

" Switch to the next/previous buffer
noremap <leader><Tab> :bn<cr>
noremap <leader><S-Tab> :bp<cr>

" fugitive
nnoremap <leader>Gg :Ggrep<SPACE>
nnoremap <leader>Gd :Gdiff<cr>
" switch back to current file and closes fugitive buffer
nnoremap <leader>GD :diffoff!<cr><C-W>h:bd<cr>

" Remap , since it's my <leader>
" Useful to go back to the previous occurence when using the f{char} motion
nnoremap \ ,

" Inserts the relative filname
"inoremap <leader>fn <c-r>=expand("%:p")<cr>
inoremap <c-f>n <c-r>=expand("%:p")<cr>

" <C-R> explained:
" You can insert the result of a Vim expression in insert mode using the <C-R>=
" command. For example, the following command creates an insert mode map command
" that inserts the current directory:
" :inoremap <F2> <C-R>=expand('%:p:h')<cr>
inoremap <Tab> <C-R>=SuperCleverTab()<cr>

" vim-grep-operator
nmap <leader>g <Plug>GrepOperatorOnCurrentDirectory
xmap <leader>g <Plug>GrepOperatorOnCurrentDirectory
nmap <leader><leader>g <Plug>GrepOperatorWithFilenamePrompt
xmap <leader><leader>g <Plug>GrepOperatorWithFilenamePrompt

" Custom mappings for the unite buffer
function! s:unite_settings()
  imap <buffer> <c-c> <Plug>(unite_exit)
  nmap <buffer> <c-c> <Plug>(unite_exit)
  nmap <buffer> <esc> <Plug>(unite_exit)
  imap <buffer> <c-l> <Plug>(unite_redraw)
  nmap <buffer> <c-l> <Plug>(unite_redraw)
  imap <buffer> <c-j> <Plug>(unite_select_next_line)
  imap <buffer> <c-k> <Plug>(unite_select_previous_line)
endfunction

" Quicker way to go into command mode
nnoremap ; :
nnoremap : ;
xnoremap ; :
xnoremap : ;

" ZZ remaped to <leader>z
nnoremap <leader>z ZZ

" The nerdtree
nnoremap <leader>nt :NERDTreeToggle<cr>

" Remaps <f1> to nothing, when you try to reach <esc> you often hit <f1>
inoremap <f1> <nop>
nnoremap <f1> <nop>
xnoremap <f1> <nop>

" Remaps esc to something easier to type
inoremap jk <esc>
inoremap <esc> <nop>

" Easy up and down on wrapped long lines:
" http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'

" Bring each tag attribute/value on its own line
" For example <a href="/foo" class="foo" id="foo"> becomes:
" <a
" href="/foo"
" class="foo"
" id="foo">
nnoremap <leader><leader>b /=<cr>BXi<cr><esc>n

" Tabs
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>tc :tabclose<cr>

" CoffeeScript
nnoremap <leader>co :CoffeeCompile<cr>

" Inspired by https://github.com/tpope/vim-unimpaired
" Sets paste on and set nopaste when leaving insert mode
" using an autocommand
nnoremap <silent> yo  :set paste<cr>o
nnoremap <silent> yO  :set paste<cr>O

" Toggles between the active and last active tab
nnoremap <leader>gt :execute 'tabnext ' . g:last_active_tab<cr>

" Switch from tab to tab quickly
nnoremap <s-h> gT
nnoremap <s-l> gt

" http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Quicker window movement
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <c-w>j <nop>
nnoremap <c-w>k <nop>
nnoremap <c-w>h <nop>
nnoremap <c-w>l <nop>

" Redraws the screen
nnoremap <leader>l <c-l>

" Window resize
nnoremap <up> <c-w>+
nnoremap <down> <c-w>-
nnoremap <left> <c-w><
nnoremap <right> <c-w>>

" Jump outside any parentheses or quotes:
inoremap jj <esc>/[)}"'\]>]<cr>a<space>

" Quicker way to trigger keyword completion and navigate through the match
" list
inoremap <c-j> <c-n>
inoremap <c-k> <c-p>
inoremap <c-n> <nop>
inoremap <c-p> <nop>
" }}}

" Abbreviations {{{
inoreabbrev xr print_r($
inoreabbrev xv var_dump($
inoreabbrev fu function
inoreabbrev xe error_log();<esc>hi
" }}}

" Vundle plugins {{{

" vundle
filetype off    " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/vundle'

" Repos on github
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-markdown'
Plugin 'inside/snipMate'
Plugin 'inside/vim-grep-operator'
Plugin 'inside/vim-search-pulse'
Plugin 'inside/CSScomb-for-Vim'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/unite-outline'
Plugin 'Shougo/neomru.vim'
Plugin 'tsukkee/unite-tag'
Plugin 'Shougo/vimproc.vim'
Plugin 'kmnk/vim-unite-giti'
Plugin 'inside/vimwiki'
Plugin 'beyondwords/vim-twig'
Plugin 'mattn/emmet-vim'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'Raimondi/delimitMate'
Plugin 'airblade/vim-gitgutter'
Plugin 'bling/vim-airline'
Plugin 'davidhalter/jedi-vim'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'kchmck/vim-coffee-script'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'sjl/gundo.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'tpope/vim-dispatch'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'digitaltoad/vim-jade'
Plugin 'rking/ag.vim'
Plugin 'mhinz/vim-startify'
Plugin 'tobyS/vmustache'
Plugin 'tobyS/pdv'

" Github vim-scripts repos
Plugin 'L9'
Plugin 'Syntastic'
Plugin 'Toggle'
Plugin 'camelcasemotion'
Plugin 'CursorLineCurrentWindow'

call vundle#end() " required
filetype plugin indent on " required
" }}}

" Plugins configuration {{{

" Syntastic
" Available checkers are: php, phpcs, phpmd.
" Let's stick to the php executable only.
let g:syntastic_php_checkers = ['php']
let g:syntastic_coffee_checkers = ['coffeelint']
let g:syntastic_coffee_coffeelint_args = "--csv -f ~/.coffeelint.json"
let g:syntastic_mode_map = {'passive_filetypes': ['html']}

" Unite
let g:unite_source_rec_max_cache_files = 100000
let g:unite_prompt = '» '
let g:unite_source_rec_async_command =
      \ 'ag --follow --nocolor --nogroup -g ""'
let g:unite_data_directory = expand('~/.cache/unite')

" Toggle
nnoremap <leader>t :call Toggle()<cr>

" Vimwiki
" Don't use noremap
nmap <leader>W <Plug>VimwikiIndex

" delimitMate
let delimitMate_expand_cr = 1

" vim-git-gutter
let g:gitgutter_eager = 0

" vim-airline
let g:airline_enable_syntastic = 0
let g:airline_theme = 'solarized'

" emmet
let g:user_emmet_leader_key = '<c-e>'
let g:user_emmet_mode = 'iv'  " enable zencoding in insert and visual modes

" jedi-vim
let g:jedi#goto_assignments_command = ''
let g:jedi#rename_command = ''

" Search pulse
let g:vim_search_pulse_mode = 'pattern'

" CoffeeScript
let g:coffee_lint_options = '-f ~/.coffeelint.json'

" trailing-whitespace
let g:extra_whitespace_ignored_filetypes = ['unite']

" ag.vim
" The --vimgrep option is implemented in my fork of ag:
" https://github.com/inside/the_silver_searcher
let g:agprg = 'ag --vimgrep'

" The vim grep operator
let g:grep_operator = 'Ag'

" Startify
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let g:startify_custom_indices = ['a', 'f', 'h']
let g:startify_enable_special = 0
let g:startify_list_order = [
      \ ['  Sessions:'],
      \ 'sessions',
      \ ['  Last recently opened files:'],
      \ 'files',
      \ ['  Last recently modified files in the current directory:'],
      \ 'dir',
      \ ['  Bookmarks:'],
      \ 'bookmarks',
      \ ]
let g:startify_relative_path = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_dir = '~/.vimsessions'
let g:startify_session_persistence = 1

" pdv
let g:pdv_template_dir = expand('~/.vim/bundle/pdv/templates')
nnoremap <c-p> :call pdv#DocumentCurrentLine()<cr>

" }}}

" Colorscheme {{{
" When solarized is not configured on the terminal,
" my prefered colorscheme is darkburn.
"colorscheme darkburn
colorscheme solarized
" }}}

" Autocommands {{{
augroup mygroup
  " clear the group's autocommand
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType make setlocal noexpandtab
  " See: http://bjori.blogspot.fr/2010/01/unix-manual-pages-for-php-functions.html
  autocmd FileType php setlocal keywordprg=pman
  autocmd BufNewFile,BufRead *.as     set filetype=actionscript
  autocmd BufNewFile,BufRead *.html   set filetype=html.twig
  autocmd BufNewFile,BufRead *.ejs    set filetype=html
  " Show the signs column even if it is empty, useful for the vim-git-gutter plugin
  autocmd BufEnter * sign define dummy
  autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
  autocmd FileType unite call s:unite_settings()
  " I don't want the docstring window to popup during completion
  autocmd FileType python setlocal completeopt-=preview

  " Thanks to http://tilvim.com/2013/05/29/comment-prefix.html
  " I don't want comment prefixing on a new line
  autocmd FileType * setlocal formatoptions-=o formatoptions-=r

  " Disables paste mode when leaving insert mode
  autocmd InsertLeave *
        \ if &paste == 1 |
        \   set nopaste |
        \ endif

  " Toggles between the active and last active tab
  autocmd TabLeave * let g:last_active_tab = tabpagenr()

  "autocmd BufRead,BufNewFile,BufEnter *
  autocmd BufEnter *
        \ silent! unabbreviate cl |
        \ if &filetype == 'coffee' |
        \   inoreabbrev cl console.log |
        \ elseif index(['javascript', 'ejs'], &filetype) != -1 |
        \   inoreabbrev cl console.log();<esc>hi

  autocmd Filetype qf setlocal nowrap
augroup END
" }}}

" User defined commands {{{

" Shortcut to :Ag
command! -complete=file -nargs=+ G :Ag! <args>
" }}}

" Loads a local configuration {{{
if filereadable($HOME . '/.vimrc.local')
  source $HOME/.vimrc.local
endif
" }}}
