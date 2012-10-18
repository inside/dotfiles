""""""""""""""""""""""""""""
" Variables initialization "
""""""""""""""""""""""""""""

let mapleader = ","

"""""""""""
" General "
"""""""""""

set nocp    " 'compatible' is not set
set path+=lib,lib/DM,lib/DM/DBObject,src,views    " Tell vim to look for these directories
                                            " when doing gf :find , see :h path
set tags=~/.vim/tags/dailymotion    " This is mandatory for omni completion
                                    " of user defined classes, methods, functions
set termencoding=utf-8
set hidden
set lz  " Do not redraw while running macros (much faster) (LazyRedraw)
set infercase
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/backup " Stores swap files there
set writebackup
set mouse=a
set ttymouse=xterm2 " Make mouse work on virtual terms like screen
set ww=b,s,<,>
set wildignore+=*.o,*.obj,*.git*,*cache/*,*gen/*

" Visual options
set showmatch
set nonu
set ruler
set vb
set wildmenu
set wildmode=list:longest,full
set guicursor+=a:blinkon0

" Text formatting
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set bs=2
set textwidth=0
set ai
set ignorecase
set foldmethod=syntax
set nofoldenable    " Folding should only be enabled on small files,
                    " otherwise it take too much resources

" Vim UI
set laststatus=2
set showcmd
set showmode

" Theme/Colors
" See http://www.vim.org/tips/tip.php?tip_id=1312
" 256 colors may be needed for any other colorscheme exexpt solarized
"set t_Co=256
" Needed for solarized: Use the 16 colors terminal option to get VIM to look
" like GVIM with solarized colors.
set t_Co=16
syntax on
set background=dark

""""""""""""""""
" Autocommands "
""""""""""""""""

if !exists("autocommands_loaded")
    let autocommands_loaded = 1
    au BufNewFile,BufRead Makefile set noexpandtab
    au BufNewFile,BufRead *.as     set ft=actionscript
endif

""""""""""""
" Mappings "
""""""""""""

set winaltkeys=no

" Toggles highlight search
nnoremap <Leader>h :set invhlsearch<CR>

" Edit ~/.vimrc or ~/.zshrc
map <Leader>es :e ~/.vimrc<Enter>
map <Leader>ez :e ~/.zshrc<Enter>

" Source ~/.vimrc or ~/.zshrc
map <Leader>so :w<Enter>:source ~/.vimrc<Enter>
map <Leader>sz :w<Enter>:!source ~/.zshrc<Enter>

" Hashrocket shortcut compliments of TextMate
imap <C-L> <space>=><space>

" make pack
map <Leader>m :!make pack<CR>

" Toggle paste on or off
map <Leader>sp :call TogglePaste()<CR>

" Toggle mouse on or off
map <Leader><CR> :call ToggleActiveMouse()<CR>

" call the tagbar window
nmap tt :TagbarToggle<CR>

" A quicker way to call the macro a
map <F2> @a

" Command-t
map <Leader>ff :CommandT<space>
map <Leader>fb :CommandTBuffer<CR>

" NERDTree
nmap <Leader>n :NERDTreeToggle<CR>

" Execute file within vim
nmap <F12> :call ExecFile()<Enter>

" Switch to the previous buffer
map <F9> :b!#<Enter>

" Control-s seems to be universal for saving files
" and also quicker than :w<enter>
map <C-s> :w<enter>

" Switch to the next buffer
nmap <Tab> :bn<Enter>

" Switch to the previous buffer
nmap <S-Tab> :bp<Enter>

" Quicker way to delete a buffer
map <del> :BD<Enter>

" Press {{, ((, [[ and it will insert the corresponding {, (, [
inoremap {{ {}<esc>i
inoremap (( ()<esc>i
inoremap [[ []<esc>i

" Opens lynx and search php.net for the word under the cursor
nmap  :!lynx -accept_all_cookies http://fr2.php.net/\#function.<CR>

" run java
map <Leader>r :!ant run<Enter>

" The Project plugin
nmap <silent> <Leader>p :Project<CR>

" fugitive
nnoremap <Leader>gg :Ggrep<SPACE>
nnoremap <Leader>gd :Gdiff<CR>
" switch back to current file and closes fugitive buffer
nnoremap <Leader>gD :diffoff!<CR><C-W>h:bd<CR> 

" numbers
nnoremap <Leader>1 :NumbersToggle<CR>

"""""""""""""""""
" Abbreviations "
"""""""""""""""""

ab xr print_r($
ab xv var_dump($
ab xe error_log(
ab cl console.log(
ab fu function

""""""""""""""""""""""""
" Plugin configuration "
""""""""""""""""""""""""

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
Bundle 'mattn/zencoding-vim'
Bundle 'inside/snipMate'
Bundle 'inside/actionscript.vim'
Bundle 'inside/fortuneod'
Bundle 'inside/selfinder'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-repeat'
Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'wincent/Command-T'
Bundle 'spolu/dwm.vim'
Bundle 'miripiruni/CSScomb-for-Vim'
Bundle 'vim-scripts/vimwiki'
Bundle 'godlygeek/tabular'
Bundle 'myusuf3/numbers.vim'
Bundle 'altercation/vim-colors-solarized'

" Github vim-scripts repos
Bundle 'L9'
Bundle 'bufkill.vim'
Bundle 'cecutil'
Bundle 'matchit.zip'
Bundle 'project.tar.gz'
Bundle 'sessionman.vim'
Bundle 'Syntastic'
Bundle 'ZoomWin'
Bundle 'darkburn'

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

" Syntastic
let g:syntastic_phpcs_disable = 1

" Command-t
let g:CommandTMaxFiles = 100000

" Colors
" When solarized is not configured on the terminal,
" my prefered colorscheme is darkburn.
"colorscheme darkburn
colorscheme solarized

""""""""""""""""""
" User functions "
""""""""""""""""""

function! ToggleActiveMouse()
    if &mouse == "a"
        exe "set mouse="
        echo "Mouse is off"
    else
        exe "set mouse=a"
        echo "Mouse is on"
    endif
endfunction

function! TogglePaste()
    if &paste == "0"
        exe "set paste"
        echo "Set paste called"
    else
        exe "set nopaste"
        echo "Set nopaste called"
    endif
endfunction

" Execute the current file trough the appropriate interpreter
function! ExecFile()
    if &ft == 'ruby'
        :w
        :!ruby %
    elseif &ft == 'actionscript'
        :w
        :!mxmlc -debug % && fdb Main.swf
    elseif &ft == 'php'
        :w
        :!php %
    else
        :w
        :!./%
    endif
endfunction
