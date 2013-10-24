" Variables initialization {{{
let mapleader = ","
" Disables match paren from the pi_paren standard plugin
let g:loaded_matchparen = 1
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

function! TogglePaste()
    set invpaste
    echo &paste == "1" ? "Set paste called" : "Set nopaste called"
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

" Better complete menu navigation
" found here: http://stackoverflow.com/a/2170800/70778
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<c-n>"
        elseif a:action == 'k'
            return "\<c-p>"
        endif
    endif
    return a:action
endfunction

inoremap <silent><c-j> <c-r>=OmniPopup('j')<cr>
inoremap <silent><c-k> <c-r>=OmniPopup('k')<cr>
" }}}

" General options {{{

" 'compatible' is not set
set nocompatible
set incsearch

" Useful for jumps
set tags=~/.vim/tags/dailymotion

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
set wildignore+=*.o,*.obj,*.git*,*cache/*,*gen/*
set history=200
set grepprg=git\ grep\ -n\ $*

" Disable setting options by file like /* vim: set sw=2: */
set nomodeline
set colorcolumn=80
" Use only 1 space after "." when joining lines instead of 2
set nojoinspaces
set showbreak=↪\ " Character to precede line wraps
" }}}

" Visual options {{{
set showmatch
set nohlsearch
set ruler
set visualbell
set wildmenu
set wildmode=list:longest,full
set guicursor+=a:blinkon0
" }}}

" Text formatting options {{{
set shiftwidth=4
set softtabstop=4
set tabstop=4
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
" 256 colors may be needed for any other colorscheme exexpt solarized
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

" Toggles highlight search
nnoremap <silent> <leader>h :set invhlsearch<cr>

" Edit ~/.vimrc or ~/.zshrc
nnoremap <leader>E :edit $MYVIMRC<cr>
nnoremap <leader>Z :edit ~/.zshrc<cr>

" Source my vimrc
nnoremap <leader>S :source $MYVIMRC<cr>

" make pack
nnoremap <leader>m :!make pack<cr>

" Toggle paste on or off
nnoremap <leader>sp :call TogglePaste()<cr>

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
inoremap <c-s> <c-o>:w<cr><esc>
nnoremap <c-s> :w<cr>

" Switch to the next/previous buffer
noremap <leader><Tab> :bn<cr>
noremap <leader><S-Tab> :bp<cr>

" Quicker way to delete a buffer
nnoremap <del> :BD<cr>

" run java
nnoremap <leader>r :!ant run<cr>

" fugitive
nnoremap <leader>Gg :Ggrep<SPACE>
nnoremap <leader>Gd :Gdiff<cr>
" switch back to current file and closes fugitive buffer
nnoremap <leader>GD :diffoff!<cr><C-W>h:bd<cr>

" PDV-revised
nnoremap <C-p> :call PhpDoc()<cr>

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
vmap <leader>g <Plug>GrepOperatorOnCurrentDirectory
nmap <leader><leader>g <Plug>GrepOperatorWithFilenamePrompt
vmap <leader><leader>g <Plug>GrepOperatorWithFilenamePrompt

" Custom mappings for the unite buffer
function! s:unite_settings()
    imap <buffer> <c-c> <Plug>(unite_exit)
    nmap <buffer> <c-c> <Plug>(unite_exit)
    nmap <buffer> <esc> <Plug>(unite_exit)
    imap <buffer> <F5>  <Plug>(unite_redraw)
    nmap <buffer> <F5>  <Plug>(unite_redraw)
    imap <buffer> <c-j> <Plug>(unite_select_next_line)
    imap <buffer> <c-k> <Plug>(unite_select_previous_line)
endfunction

" Quicker way to go into command mode
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" ZZ remaped to <leader>z
nnoremap <leader>z ZZ

" vim-search-pulse
nmap n n<Plug>PulseCursorLine
nmap N N<Plug>PulseCursorLine
nmap * *<Plug>PulseCursorLine
nmap # #<Plug>PulseCursorLine
cmap <enter> <Plug>PulseFirst

" The nerdtree
nnoremap <leader>nt :NERDTreeToggle<cr>

" Remaps <f1> to nothing, when you try to reach <esc> you often hit <f1>
inoremap <f1> <nop>
nnoremap <f1> <nop>
vnoremap <f1> <nop>

" Remaps esc to something easier to type
inoremap jk <esc>
inoremap <esc> <nop>

" Easy up and down on wrapped long lines
nnoremap j gj
nnoremap k gk
" }}}

" Abbreviations {{{
inoreabbrev xr print_r($
inoreabbrev xv var_dump($
inoreabbrev fu function
inoreabbrev xe error_log();<esc>hi
inoreabbrev cl console.log();<esc>hi
" }}}

" Vundle plugins {{{

" vundle
filetype off    " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" Repos on github
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
"Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-repeat'
Bundle 'inside/snipMate'
Bundle 'inside/actionscript.vim'
Bundle 'inside/fortuneod'
Bundle 'inside/vim-grep-operator'
Bundle 'inside/vim-search-pulse'
Bundle 'inside/CSScomb-for-Vim'
Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/unite-outline'
Bundle 'Shougo/vimproc.vim'
Bundle 'inside/unite-argument'
Bundle 'kmnk/vim-unite-giti'
Bundle 'vim-scripts/vimwiki'
Bundle 'godlygeek/tabular'
Bundle 'altercation/vim-colors-solarized'
Bundle 'beyondwords/vim-twig'
Bundle 'mattn/emmet-vim'
Bundle 'nelstrom/vim-visual-star-search'
Bundle 'Raimondi/delimitMate'
Bundle 'othree/xml.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'bling/vim-airline'
Bundle 'inside/jedi-vim'
Bundle 'hynek/vim-python-pep8-indent'
"Bundle 'ivyl/vim-bling'

" Github vim-scripts repos
Bundle 'L9'
Bundle 'bufkill.vim'
Bundle 'matchit.zip'
Bundle 'project.tar.gz'
Bundle 'sessionman.vim'
Bundle 'Syntastic'
Bundle 'darkburn'
Bundle 'PDV--phpDocumentor-for-Vim'
Bundle 'Toggle'
Bundle 'camelcasemotion'
Bundle 'CursorLineCurrentWindow'

" Non github repos
"Bundle 'git://git.wincent.com/command-t.git'

filetype plugin indent on   " required!

" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
" }}}

" Plugins configuration {{{

" Syntastic
" Available checkers are: php, phpcs, phpmd.
" Let's stick to the php executable only.
let g:syntastic_php_checkers = ['php']
let g:syntastic_mode_map = {'passive_filetypes': ['html']}

" Unite
let g:unite_source_rec_max_cache_files = 100000
let g:unite_prompt = '» '

" Fortuneod
let g:fortuneod_botright_split = 0

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
    " Show the signs column even if it is empty, useful for the vim-git-gutter plugin
    autocmd BufEnter * sign define dummy
    autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
    autocmd FileType unite call s:unite_settings()
    " I don't want the docstring window to popup during completion
    autocmd FileType python setlocal completeopt-=preview

    " Thanks to http://tilvim.com/2013/05/29/comment-prefix.html
    " I don't want comment prefixing on a new line
    autocmd FileType * setlocal formatoptions-=o | setlocal formatoptions-=r
augroup END
" }}}
