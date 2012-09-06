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

" Visual options
set showmatch
set nonu
set nohls
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
set t_Co=256    " See http://www.vim.org/tips/tip.php?tip_id=1312
syntax on
set background=dark
colorscheme darkburn

""""""""""""""""
" Autocommands "
""""""""""""""""

if !exists("autocommands_loaded")
    let autocommands_loaded = 1
    au BufNewFile,BufRead Makefile set noexpandtab
    au BufNewFile,BufRead *.as     set ft=actionscript
endif

au VimEnter * unmap <C-c>
au VimEnter * map <C-c> :TC<Enter>j

""""""""""""
" Mappings "
""""""""""""

set winaltkeys=no

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
map <C-m> :call ToggleActiveMouse()<CR>

" call the taglist window
noremap tt :Tlist<Enter>

" A quicker way to call the macro a
map <F2> @a

" Call the FuzzyFinder file or tag
map <Leader>ff :FufFile<CR>

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

" The YankRing.vim plugin
nnoremap <silent> <Leader>y :YRShow<CR>

map <Leader>f :call ShowFuncName()<CR>

"""""""""""""""""
" Abbreviations "
"""""""""""""""""

ab xr print_r($
ab xv var_dump($
ab xe error_log(
ab cl console.log(
ab fu function
ab xhtml <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"<CR>"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><CR><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr"><CR><head><CR><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><CR><title></title><CR></head><CR><body><CR></body><CR></html>
ab xcss <style type="text/css"><CR></style>
ab xjs <script type="text/javascript"><CR></script>
ab xlinkcss <link rel="stylesheet" href="" />
ab xlinkjs <script type="text/javascript" src=""></script>

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
"Bundle 'tpope/vim-fugitive'
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'mattn/zencoding-vim'
"Bundle 'tpope/vim-rails.git'
Bundle 'inside/snipMate'
Bundle 'inside/actionscript.vim'
Bundle 'inside/fortuneod'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-repeat'

" Github vim-scripts repos
Bundle 'L9'
Bundle 'Align'
Bundle 'bufkill.vim'
Bundle 'cecutil'
Bundle 'FeralToggleCommentify.vim'
Bundle 'FuzzyFinder'
Bundle 'matchit.zip'
Bundle 'minibufexpl.vim'
Bundle 'project.tar.gz'
Bundle 'sessionman.vim'
Bundle 'Syntastic'
Bundle 'taglist.vim'
Bundle 'vcscommand.vim'
Bundle 'YankRing.vim'

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

" vcscommand
let VCSCommandDeleteOnHide = 1  " This variable, if set to a non-zero value,
                                " causes the temporary result buffers
                                " to automatically delete themselves when hidden.
let VCSCommandEdit = 1  " This variable controls whether
                        " the original buffer is replaced ('edit') or
                        " split ('split').  If not set, it defaults to 'split'.

" minibufexpl
let g:miniBufExplUseSingleClick = 1

" Taglist
let g:Tlist_Use_Horiz_Window = 0
let g:Tlist_Use_Right_Window = 1
let Tlist_Auto_Highlight_Tag = 0
let Tlist_Auto_Open = 0
let Tlist_Show_One_File = 1
let Tlist_Sort_Type = 'name'
let tlist_actionscript_settings = 'actionscript;c:class;f:method;p:property;v:variable'

" FuzzyFinder
let g:fuf_file_exclude = '\v\~$|\.(o|exe|dll|bak|orig|swp)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])'
let g:fuf_ignoreCase = 1
let g:fuf_abbrevMap = {
\            "dm" : [
\                "~/dailymotion/css/",
\                "~/dailymotion/css/**/",
\                "~/dailymotion/js/",
\                "~/dailymotion/js/**/",
\                "~/dailymotion/lib/",
\                "~/dailymotion/lib/**/",
\                "~/dailymotion/views/",
\                "~/dailymotion/views/**/",
\                "~/dailymotion/controllers/",
\                "~/dailymotion/controllers/**/",
\            ],
\            "sf" : [
\                "/home/inside/Symfony/",
\                "/home/inside/Symfony/**/",
\            ],
\            "my" : [
\                "/var/www/myzf/application/",
\                "/var/www/myzf/application/**/",
\                "/var/www/myzf/library/Model/",
\                "/var/www/myzf/library/Model/**/",
\            ],
\}

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

fun! ShowFuncName()
    let lnum = line(".")
    let col = col(".")

    echohl ModeMsg
    echo getline(search("?private\\|public\\|protected\\|procedure\\|function\\s\\+\.*(", 'bW'))
    echohl None
    call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfunction
