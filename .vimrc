" Variables initialization {{{
" Thanks to http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
let mapleader = "\<space>"
" Disables match paren from the pi_paren standard plugin
let g:loaded_matchparen = 1
let g:last_active_tab = 1
" }}}

" User functions {{{
func! s:ToggleActiveMouse()
  if &mouse ==# "nv"
    set mouse=
    echo "Mouse is off"
  else
    set mouse=nv
    echo "Mouse is on"
  endif
endfunc

" This can conflict with the default mappings provided by snipmate.
" See the after directory in .vim/bundle/snipMate/after
func! s:SuperCleverTab()
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
endfunc

" Prevents variable from being over written when sourcing ~/.vimrc
if exists('g:tmux_pane_open') == 0
  let g:tmux_pane_open = 0
endif

func! s:ToggleTmuxPane()
  if g:tmux_pane_open == 0
    call system('tmux split-window -v -p 20')
    let g:tmux_pane_open = 1
  else
    call system('tmux kill-pane -t 1.2')
    let g:tmux_pane_open = 0
  endif
endfunc

" Go to next/previous SGML tag
" Credit goes to https://github.com/tejr/nextag/blob/master/plugin/nextag.vim
func! s:NextTag(direction)
  let ptn = '\m<\/\?\w\+[^>]*>'

  if a:direction ==# 'next'
    call search(ptn)
  elseif a:direction ==# 'previous'
    call search(ptn, 'b')
  endif
endfunc

" Helper to create aliases for vim commands.
" Thanks to
" http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
func! s:Alias(alias, cmd)
  execute
        \ printf('cnoreabbrev %s ', a:alias) .
        \ '<c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? ' .
        \ printf('"%s" : "%s"<cr>', a:cmd, a:alias)
endfunc

func! s:PrepageCommitMessage()
  let file_head = expand('%:p:h')

  if !filereadable(file_head . '/MERGE_MSG') &&
        \ !filereadable(file_head . '/SQUASH_MSG')
    " Note the trailing space at the end of the normal command
    execute 'normal f(i '
    startinsert
  endif
endfunc

" To consume the character typed after an abbreviation
" See :helpgrep Eatchar
func! s:Eatchar(pat)
  let c = nr2char(getchar(0))

  return (c =~# a:pat) ? '' : c
endfunc

func! s:ToggleNumbers()
  set invnumber
  set invrelativenumber
endfunc

" Custom mappings for the unite buffer
func! s:unite_settings()
  imap <buffer> <c-c> <Plug>(unite_exit)
  nmap <buffer> <c-c> <Plug>(unite_exit)
  nmap <buffer> <esc> <Plug>(unite_exit)
  imap <buffer> <c-l> <Plug>(unite_redraw)
  nmap <buffer> <c-l> <Plug>(unite_redraw)
  imap <buffer> <c-j> <Plug>(unite_select_next_line)
  imap <buffer> <c-k> <Plug>(unite_select_previous_line)
endfunc

" Lowercase inner word
func! s:ChangeInnerWordCase(case)
  let col = virtcol('.')

  execute 'normal ' . (a:case ==# 'lower' ? 'guiw' : 'gUiw')
  execute 'normal ' . col . '|'
endfunc

" Toggle capitalize inner word
func! s:ToggleCapitalizeInnerWord()
  let col = virtcol('.')

  execute 'normal b~'
  execute 'normal ' . col . '|'
endfunc

func! s:NextTextObject(motion, dir)
  let text_object = nr2char(getchar())

  if text_object ==# 'b'
    let text_object = '('
  elseif text_object ==# 'B'
    let text_object = '{'
  elseif text_object ==# 'm'
    let text_object = '['
  endif

  execute 'normal! ' . a:dir . text_object . 'v' . a:motion . text_object
endfunc

func! s:Colorscheme(name)
  if a:name ==# 'solarized'
    " Needed for solarized: Use the 16 colors terminal option to get VIM to look
    " like GVIM with solarized colors.
    set t_Co=16
  else
    " See http://www.vim.org/tips/tip.php?tip_id=1312
    " 256 colors may be needed for any other colorscheme except solarized
    set t_Co&vim
  endif

  execute 'colorscheme ' . a:name
endfunc

func! s:SetIndentSize(spaces)
  if type(str2nr(a:spaces)) != 0
    return
  endif

  execute 'setlocal shiftwidth=' . a:spaces
  execute 'setlocal softtabstop=' . a:spaces
  execute 'setlocal tabstop=' . a:spaces
endfunc

" requires https://github.com/godlygeek/windowlayout
func! s:UndoCloseTab()
  if exists("s:layout") && !empty(s:layout)
    tabnew
    call windowlayout#SetLayout(s:layout)
    unlet s:layout
  endif
endfunc

func! s:CloseTab()
  let s:layout = windowlayout#GetLayout()
  tabclose
endfunc

function! s:LineMotion(dir)
  if v:count == 0
    return 'g' . a:dir
  endif
  return ":\<C-u>normal! m'" . v:count . a:dir . "\<CR>"
endfunction
" }}}

" User defined commands {{{
" Create an alias
command! -nargs=+ Alias call <sid>Alias(<f-args>)

" My own colorscheme command
command! -complete=color -nargs=1 Colorscheme call <sid>Colorscheme(<f-args>)
Alias cs Colorscheme

" Shortcut to :Ag
command! -complete=file -nargs=+ G :Ag! <args>

" Change indent size quickly
command! -nargs=1 SetIndentSize call <sid>SetIndentSize(<f-args>)
Alias sis SetIndentSize

" For restoring a closed tab and its window layout
command! UndoCloseTab call s:UndoCloseTab()
command! CloseTab call s:CloseTab()

" Save one key stroke for grepping
Alias g G

" Fugitive aliases
Alias gr Gread
Alias gw Gwrite
Alias gs Gstatus
Alias gci Gcommit
Alias gd Gdiff
Alias gm Gmerge
Alias gb Gblame
Alias gi Git
" }}}

" General options {{{
set incsearch
set complete-=t " Don't look for tags when completing
set complete-=i " Don't look for included files
set termencoding=utf-8
set hidden
set lazyredraw " Do not redraw while running macros (much faster)
set infercase " Case sensitive insert completion even if ingorecase is set
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/backup " Stores swap files there
set writebackup
set mouse=

if !has('nvim')
  set ttymouse=xterm2 " Make mouse work on virtual terms like screen
  set nocompatible
endif

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
set undofile
set undodir=~/.vim/undofiles

" https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally
" Open new split panes to right and bottom, which feels more natural than
" Vim's default
set splitbelow
set splitright

" Reloads the file if it has been changed outside of vim.
set autoread
set winaltkeys=no

" Used for the CursorHold autocommand event and thud by the auto-save plugin
set updatetime=750
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
set number
set list
let &listchars='tab:▸ '
" Don't colorize syntax after 512 characters
set synmaxcol=512

" For at least vim >= 7.4.338
if has('patch-7.4.338')
  set breakindent
endif

set linebreak
" }}}

" Text formatting options {{{
" For clarity's sake use the same value for these 3 options.
" See http://vimcasts.org/episodes/tabs-and-spaces/ for a full explanation.
set shiftwidth=4 softtabstop=4 tabstop=4
" Always round the indent to a multiple of 'shiftwidth'
set shiftround
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

" Mappings {{{
" Get to know the current pattern count match
nnoremap <leader>o :%s///gn<cr>

" Quick way to recall macro a
nnoremap <leader>2 @q

" Quick way to recall last command
nnoremap <leader>3 @:

" Edit ~/.vimrc or ~/.zshrc
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>ez :edit ~/.zshrc<cr>

" Source my vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" Toggle mouse on or off
nnoremap <leader><cr> :call <sid>ToggleActiveMouse()<cr>

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
nnoremap <silent> <leader>fm
      \ :<c-u>Unite
      \ -no-split -buffer-name=files -start-insert
      \ file_mru<cr>
nnoremap <silent> <leader>fc
      \ :<c-u>UniteWithBufferDir
      \ -no-split -buffer-name=files -start-insert
      \ file_rec/async<cr>
nnoremap <silent> <leader>fa
      \ :<c-u>Unite
      \ -no-split -buffer-name=buffers -start-insert
      \ argument<cr>

" Switch to the next/previous buffer
noremap <leader><Tab> :bn<cr>
noremap <leader><S-Tab> :bp<cr>

" fugitive
nnoremap <leader>Gd :Gdiff<cr>
" switch back to current file and closes fugitive buffer
nnoremap <leader>GD :diffoff!<cr><C-W>h:bd<cr>

" Inserts the relative filname
inoremap <c-f>n <c-r>=expand("%:p")<cr>

" <C-R> explained:
" You can insert the result of a Vim expression in insert mode using the <C-R>=
" command. For example, the following command creates an insert mode map command
" that inserts the current directory:
" :inoremap <F2> <C-R>=expand('%:p:h')<cr>
inoremap <Tab> <C-R>=<sid>SuperCleverTab()<cr>

" vim-grep-operator
let g:grep_operator_set_search_register = 1
nmap <leader>g <Plug>GrepOperatorOnCurrentDirectory
xmap <leader>g <Plug>GrepOperatorOnCurrentDirectory
nmap <leader><leader>g <Plug>GrepOperatorWithFilenamePrompt
xmap <leader><leader>g <Plug>GrepOperatorWithFilenamePrompt

" Quicker way to go into command mode
" This is actually ctrl-space
nnoremap <nul> :
xnoremap <nul> :

" Quicker indentation
nnoremap <cr> ==
xnoremap <cr> =

" Write and quit all buffers
nnoremap <leader>z :wqa<cr>

" Quit current window
nnoremap q :q<cr>

" Record macros using Q
nnoremap Q q

" The nerdtree
nnoremap <leader>nt :NERDTreeToggle<cr>
" Find the current file in the tree
nnoremap <leader>nf :NERDTreeFind<cr>

" Remaps <f1> to nothing, when you try to reach <esc> you often hit <f1>
inoremap <f1> <nop>
nnoremap <f1> <nop>
xnoremap <f1> <nop>

" Remaps esc to something easier to type
inoremap jk <esc>

" Bring each tag attribute/value on its own line
" For example <a href="/foo" class="foo" id="foo"> becomes:
" <a
" href="/foo"
" class="foo"
" id="foo">
nnoremap <leader><leader>b /=<cr>BXi<cr><esc>n

" Tabs
nnoremap <leader>tn :tabnew<cr>
nnoremap <Leader>tc :<C-u>CloseTab<cr>
nnoremap <Leader>tu :<C-u>UndoCloseTab<cr>

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

" Jump outside any parentheses or quotes:
inoremap jj <esc>/[)}"'\]>]<cr>a

" Quicker way to trigger keyword completion and navigate through the match
" list
inoremap <c-j> <c-n>
inoremap <c-k> <c-p>
inoremap <c-n> <nop>
inoremap <c-p> <nop>

" Bubble lines
xmap <c-k> <Plug>BubbleLinesVisualUp
xmap <c-j> <Plug>BubbleLinesVisualDown

" Most of the time I want to search for literal strings using /\V
nnoremap / /\V
nnoremap ? ?\V

" Command mode history navigation
cnoremap <c-j> <down>
cnoremap <c-k> <up>

" See spell checking correction suggestion quicker
nnoremap <leader>s a<c-x><c-s>

" Upper or lower case inner word
nnoremap <leader>u :call <sid>ChangeInnerWordCase('lower')<cr>
nnoremap <leader>U :call <sid>ChangeInnerWordCase('upper')<cr>

" Toggle capitalize inner word
nnoremap <leader>` :call <sid>ToggleCapitalizeInnerWord()<cr>

" Motion for "next/last object". For example, "din(" would go to the next "()" pair
" and delete its contents.
" https://gist.github.com/sjl/1171642
onoremap an :<c-u>call <sid>NextTextObject('a', 'f')<cr>
xnoremap an :<c-u>call <sid>NextTextObject('a', 'f')<cr>
onoremap in :<c-u>call <sid>NextTextObject('i', 'f')<cr>
xnoremap in :<c-u>call <sid>NextTextObject('i', 'f')<cr>

onoremap al :<c-u>call <sid>NextTextObject('a', 'F')<cr>
xnoremap al :<c-u>call <sid>NextTextObject('a', 'F')<cr>
onoremap il :<c-u>call <sid>NextTextObject('i', 'F')<cr>
xnoremap il :<c-u>call <sid>NextTextObject('i', 'F')<cr>

" Quickly add/remove current file to/from the argument list
nnoremap <leader>aa :argadd %<cr>
nnoremap <leader>ad :argdelete %<cr>

" To be consistent with other normal commands like D, C
nnoremap Y y$

nnoremap <leader>to :call <sid>ToggleTmuxPane()<cr>
nnoremap <silent> tn :call <sid>NextTag('next')<cr>
nnoremap <silent> tp :call <sid>NextTag('previous')<cr>
nnoremap <leader>nn :call <sid>ToggleNumbers()<cr>

" Vimwiki
" Don't use noremap
nmap <leader>W <Plug>VimwikiIndex

nnoremap <c-p> :call pdv#DocumentCurrentLine()<cr>

" vim-argumentative
nmap [a <Plug>Argumentative_Prev
nmap ]a <Plug>Argumentative_Next
xmap [a <Plug>Argumentative_XPrev
xmap ]a <Plug>Argumentative_XNext
nmap <a <Plug>Argumentative_MoveLeft
nmap >a <Plug>Argumentative_MoveRight
xmap ia <Plug>Argumentative_InnerTextObject
xmap aa <Plug>Argumentative_OuterTextObject
omap ia <Plug>Argumentative_OpPendingInnerTextObject
omap aa <Plug>Argumentative_OpPendingOuterTextObject

" Look for the next/previous number
nnoremap <silent> <expr> <leader>N <sid>NextPrevNumber('/')
nnoremap <silent> <expr> <leader>B <sid>NextPrevNumber('?')

func! s:NextPrevNumber(cmd)
  return a:cmd . "\\v[0-9]+\<cr>:call search_pulse#Pulse()\<cr>"
endfunc

" To search and replace a word, I often use a dot formula pattern described by
" Drew Neil in Practical vim:
"
" 1. press * when the cursor is on the word you want to replace
" 2. type cw
" 3. type the new word and go back to normal mode
" 4. type n. n. n. etc... to find the next match and repeat the change
"
" With the mappings below you can get rid of one step and have the benefit
" of replacing the word under the cursor, not skipping it for later
" replacement:
"
" 1. press <leader>* when the cursor is on the word you want to replace
" 2. type the new word and go back to normal mode
" 3. type n. n. n. etc... to find the next match and repeat the change

nnoremap <leader>* *Ncw

" The visual mapping only works if you have a visual star search plugin
" installed. I use a fork (https://github.com/inside/vim-visual-star-search) of
" https://github.com/nelstrom/vim-visual-star-search where I removed the
" <leader>* mappings because I use them for this purpose.

xmap <leader>* *Ngvc

" Split line == the opposite of J
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>

" Shortcut for []
onoremap im i[
onoremap am a[
xnoremap im i[
xnoremap am a[

" LineMotion
" https://www.reddit.com/r/vim/comments/3npf1z/using_jk_for_wrapped_lines_and_adding_jk_with_a/cvqe1no
nnoremap <expr> <silent> j <sid>LineMotion('j')
nnoremap <expr> <silent> k <sid>LineMotion('k')
xnoremap <expr> <silent> j <sid>LineMotion('j')
xnoremap <expr> <silent> k <sid>LineMotion('k')
nnoremap gj j
nnoremap gk k
xnoremap gj j
xnoremap gk k

if has('nvim')
  tnoremap <c-h> <C-\><C-n><C-w>h
  tnoremap <c-j> <C-\><C-n><C-w>j
  tnoremap <c-k> <C-\><C-n><C-w>k
  tnoremap <c-l> <C-\><C-n><C-w>l
endif

" Shorcut to paste and preserve indenting
nnoremap <leader>p ]p
nnoremap <leader>P ]P
xnoremap <leader>p ]p
xnoremap <leader>P ]P
" }}}

" Abbreviations {{{
inoreabbrev fu function
" }}}

" Plugins {{{
" vim-plug
" https://github.com/junegunn/vim-plug
" Installation:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" Auto installation
let s:needs_plugins = 0

if !filereadable($HOME . '/.vim/autoload/plug.vim')
  echom 'Plugin manager was not found, installing...'
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echom 'Plugin manager done.'
  let s:needs_plugins = 1
endif

call plug#begin('~/.vim/bundle')
let g:plug_url_format = 'git@github.com:%s.git'

Plug '907th/vim-auto-save'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'PeterRincker/vim-argumentative'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'SirVer/ultisnips'
Plug 'airblade/vim-gitgutter'
Plug 'beyondwords/vim-twig'
Plug 'bling/vim-airline'
Plug 'breuckelen/vim-resize'
Plug 'chrisbra/NrrwRgn'
Plug 'christoomey/vim-tmux-navigator'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'digitaltoad/vim-jade'
Plug 'editorconfig/editorconfig-vim'
Plug 'flazz/vim-colorschemes'
Plug 'glts/vim-textobj-comment'
Plug 'godlygeek/windowlayout'
Plug 'honza/vim-snippets'
Plug 'hynek/vim-python-pep8-indent'
Plug 'inside/CSScomb-for-Vim', {'for': 'css'}
Plug 'inside/unite-argument'
Plug 'inside/vim-bubble-lines'
Plug 'inside/vim-grep-operator'
Plug 'inside/vim-search-pulse'
Plug 'inside/vim-slime'
Plug 'inside/vim-visual-star-search'
Plug 'inside/vimwiki'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'kana/vim-textobj-user'
Plug 'kchmck/vim-coffee-script'
Plug 'kmnk/vim-unite-giti'
Plug 'majutsushi/tagbar'
Plug 'marijnh/tern_for_vim', {'do': 'npm install'}
Plug 'mattn/emmet-vim', {'for': ['html', 'html.twig', 'ejs']}
Plug 'mhinz/vim-startify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'rhysd/clever-f.vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/Syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'sgur/unite-qf'
Plug 'sjl/gundo.vim'
Plug 'thinca/vim-qfreplace'
Plug 'tobyS/pdv', {'for': ['php']}
Plug 'tobyS/vmustache'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tsukkee/unite-tag'
Plug 'vim-scripts/CursorLineCurrentWindow'
Plug 'vim-scripts/L9'
Plug 'vim-scripts/Toggle'
Plug 'vim-scripts/camelcasemotion'
Plug 'vim-scripts/loremipsum'
Plug 'vim-scripts/matchit.zip'
Plug 'whatyouhide/vim-textobj-xmlattr'

call plug#end()

if s:needs_plugins
  echom 'Installing plugins...'
  PlugInstall
  let s:needs_plugins = 0
endif
" }}}

" Plugins configuration {{{

" Syntastic
let g:syntastic_filetype_map = {
    \ "javascript.jsx": "jsx",
    \ }
let g:syntastic_mode_map = {
    \ "passive_filetypes": ["jsx"],
    \ }

" Available checkers are: php, phpcs, phpmd.
" Let's stick to the php executable only.
let g:syntastic_php_checkers = ['php']

" Coffee Script
let g:syntastic_coffee_checkers = ['coffeelint']
let g:syntastic_coffee_coffeelint_args = "-f ~/.coffeelint.json"

" Twig templates
" See https://github.com/asm89/twig-lint
let g:syntastic_twig_twiglint_exec = 'php'
let g:syntastic_twig_twiglint_exe = 'php ~/bin/twig-lint.phar'

" Unite
let g:unite_source_rec_max_cache_files = 100000
let g:unite_prompt = '» '
let g:unite_source_rec_async_command =
      \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', '']

let g:unite_data_directory = expand('~/.cache/unite')

" delimitMate
let delimitMate_expand_cr = 1

" vim-git-gutter
let g:gitgutter_eager = 0
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
nmap <leader>sh <Plug>GitGutterStageHunk

" vim-airline
let g:airline#extensions#syntastic#enabled = 1

" emmet
let g:user_emmet_leader_key = '<c-e>'
let g:user_emmet_mode = 'iv' " enable zencoding in insert and visual modes

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
let g:ag_prg = 'ag -Q --vimgrep'

" The vim grep operator
let g:grep_operator = 'Ag'

" Startify
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let g:startify_custom_indices = ['f', 'g', 'h']
let g:startify_enable_special = 0
let g:startify_list_order = [
            \ ['* Last recently opened files'],
            \ 'files',
            \ ['* Last recently modified files in the current directory'],
            \ 'dir',
            \ ['* Bookmarks'],
            \ 'bookmarks',
            \ ['* Sessions'],
            \ 'sessions',
            \ ]
let g:startify_relative_path = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_dir = '~/.vimsessions'
let g:startify_session_persistence = 1

" pdv
let g:pdv_template_dir = expand('~/.vim/bundle/pdv/templates')

" vim-slime
let g:slime_target = 'tmux'
let g:slime_default_config = {'socket_name': 'default', 'target_pane': '2'}

" vim-auto-save
" Enable auto save
let g:auto_save = 1
" Do not display the auto-save notification
let g:auto_save_silent = 1
" Do not save while in insert mode
let g:auto_save_in_insert_mode = 0
" Do not change the 'updatetime' option
" It is set to 400ms by this plugin
" Prefer to use 750ms
let g:auto_save_no_updatetime = 1

" Ultisnips
let g:UltiSnipsExpandTrigger = '<c-l>'
let g:UltiSnipsJumpForwardTrigger = '<c-l>'
let g:UltiSnipsJumpBackwardTrigger = '<c-b>'

" clever-f
let g:clever_f_across_no_line = 1
let g:clever_f_chars_match_any_signs = '.'
" }}}

" Color options {{{
syntax on
set background=dark
Colorscheme solarized
" }}}

" Autocommands {{{
augroup mygroup
  " clear the group's autocommand
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  " Get the vim help from the word under the cursor
  autocmd FileType vim nnoremap <buffer> <leader>he :help <c-r><c-w><cr>
  " Make files use the tab character for indentation
  autocmd FileType make setlocal noexpandtab
  " See: http://bjori.blogspot.fr/2010/01/unix-manual-pages-for-php-functions.html
  autocmd FileType php setlocal keywordprg=pman
  autocmd BufNewFile,BufRead *.ejs set filetype=ejs
  autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
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
  autocmd Filetype qf setlocal nowrap
  autocmd BufRead COMMIT_EDITMSG call <sid>PrepageCommitMessage()

  " rainbow_parentheses
  autocmd VimEnter * RainbowParentheses

  " Remaps the enter key for the qf and cmd windows
  " because I remap enter to ==
  autocmd Filetype qf nnoremap <buffer> <cr> <cr>
  autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>

  " Abbreviations
  autocmd Filetype php inoreabbrev <buffer> tt $this-><c-r>=<sid>Eatchar('\s')<cr>

  " no wrap for css
  autocmd Filetype css setlocal nowrap
  autocmd Filetype scss setlocal nowrap
augroup END

augroup linenumbering
  autocmd!
  autocmd WinLeave *
        \ if &number |
        \   set norelativenumber |
        \ endif
  autocmd WinEnter *
        \ if &number |
        \   set relativenumber |
        \ endif
augroup END

" Auto capitalize caracter when typing
" Inspired by:
" https://davidxmoody.com/vim-auto-capitalisation/
let s:capitalizer_pattern  = '\v' " Start very magic pattern matching mode
let s:capitalizer_pattern .= '(' " Begin of atom
let s:capitalizer_pattern .= '%^' " Start of the file
let s:capitalizer_pattern .= '|' " Or
let s:capitalizer_pattern .= '[.!?]\_s+' " Matches either of these punctuation
                                         " signs. Followed be one or more
                                         " whitespace which may or may not
                                         " include newlines
let s:capitalizer_pattern .= '|' " Or
let s:capitalizer_pattern .= '^\[[^\]]*\]\s+' " Matches '[foo] ' at the start
                                              " of the line. Useful for my git
                                              " commit messages
let s:capitalizer_pattern .= ')' " End of atom
let s:capitalizer_pattern .= '%#' " Matches at the cursor

func! s:Capitalizer()
  if search(s:capitalizer_pattern, 'bcnW') != 0
    let v:char = toupper(v:char)
  endif
endfunc

augroup sentences
  autocmd!
  autocmd InsertCharPre COMMIT_EDITMSG call s:Capitalizer()
  autocmd InsertCharPre *.md call s:Capitalizer()
  autocmd InsertCharPre *.txt call s:Capitalizer()
augroup END
" }}}

" Loads a local configuration {{{
if filereadable($HOME . '/.vimrc.local')
  source $HOME/.vimrc.local
endif
" }}}
