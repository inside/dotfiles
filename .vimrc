" Initialize some variables
let mapleader = ","

" General {{{

" from Gary Bernhardt: don't close splits when deleting buffer
cnoremap <expr> bd (getcmdtype() == ':' ? 'Bclose' : 'bd')

let php_sql_query = 1
set nocp		        " 'compatible' is not set
filetype plugin indent on	    " plugins are enabled


" Tell vim to look for these directories when doing gf :find , see :h path
set path+=lib,lib/DM,lib/DM/DBObject,src

" set some tag files generated from ctags -R [dir_to_project]
" this is mandatory for omni completion of user defined classes, methods, functions
" see :h new-omni-completion
"function! SetTag()
"    if (getcwd() == '/mnt/svn/nakama/branches/revolution')
"        set tags=~/.vim/tags/nakama_branches_revolution
"    elseif (getcwd() == '/mnt/svn/nakama/trunk')
"        set tags=~/.vim/tags/nakama_trunk
"    elseif (getcwd() == '/home/yann/dailymotion')
"        set tags=~/.vim/tags/dailymotion
"    endif
"endfunction
"
"call SetTag()
set tags=~/.vim/tags/dailymotion

" make dictionary completion source part of the default completion sources
"set complete-=k complete+=k
"set dictionary+=~/.vim/dictionary/funclist.txt

"set fileencodings=latin1
"set encoding=latin1
set termencoding=utf-8
set hidden
" Do not redraw while running macros (much faster) (LazyRedraw)
set lz
set infercase
set backup
set backupdir=~/.vim/backup
" Stores swap files there
set directory=~/.vim/backup
set writebackup
set mouse=a
" make mouse work on virtual terms like screen
set ttymouse=xterm2
set ww=b,s,<,>
" }}}

" Visual options {{{
set showmatch
set nonu
set nohls
set ruler
set vb
set wildmenu
set wildmode=list:longest,full 
set guicursor+=a:blinkon0
" }}}

" Text formatting {{{
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set bs=2
set textwidth=0
set ai
set ignorecase
set foldmethod=syntax

"let php_folding = 1   " fold/unfold classes and functions
"let php_folding = 2   " fold/unfold any {} blocks

set nofoldenable " folding should anly be enabled on small files, otherwise it take too much resources
" }}}

" Vim UI {{{
set laststatus=2
"set statusline=[%04l-%04L,%04v]\ %F%m%r%h%w\ %p%%
set showcmd
set showmode
"set verbose=9
" vim will correct me if I type if ($foo = $bar)
" inoreabbr <expr> = getline('.') =~ '\s*if\s*\s([^=]*=$' ? '==' : '='
" }}}

" Theme/Colors {{{
set t_Co=256 " See http://www.vim.org/tips/tip.php?tip_id=1312
syntax on
set background=dark
colorscheme darkburn
" }}}

" Autocommands {{{
":augroup my_tab
if !exists("autocommands_loaded")
    let autocommands_loaded = 1
    au BufNewFile,BufRead *.php    set shiftwidth=4 softtabstop=4 tabstop=4
    " vim will warn me if I type if ($foo = $bar)
    "au BufNewFile,BufRead *.php match ErrorMsg '\(if\|while\)\s*([^=(!<>]*=[^=].*'
    au BufNewFile,BufRead *.html   set shiftwidth=4 softtabstop=4 tabstop=4
    au BufNewFile,BufRead *.css    set shiftwidth=4 softtabstop=4 tabstop=4
    au BufNewFile,BufRead *.js     set shiftwidth=4 softtabstop=4 tabstop=4
"    au BufNewFile,BufRead *.tpl    set shiftwidth=2 softtabstop=2 tabstop=2 ft=html syntax=smarty
"    au BufNewFile,BufRead *.phtml  set shiftwidth=2 softtabstop=2 tabstop=2 ft=php " all my .phtml files ARE php
    au BufNewFile,BufRead Makefile set noexpandtab
    au BufNewFile,BufRead *.as     set ft=actionscript
endif
au BufNewFile,BufRead Makefile set noexpandtab
au BufNewFile,BufRead *.as     set ft=actionscript
" }}}

" Mappings {{{

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

" make the dmplayer
map <Leader>mf :!cd flash/dmplayerv4 && make<CR>

" Toggle paste on or off
map <Leader>sp :call TogglePaste()<CR>

" Toggle mouse on or off
map <C-m> :call ToggleActiveMouse()<CR>

" Toggle hls
nmap <silent> <C-n> :silent call ToggleHLSearch()<CR> 

" call the taglist window
noremap tt :Tlist<Enter>

" A quicker way to call the macro a
map <F2> @a

" Insert php tags when editing a new php file
map <F3> i<?php<Esc>o<enter>

" Call phpdoc
map <F5> :call PhpDocSingle()<CR>

" Call the FuzzyFinder file or tag
map <F6> :FuzzyFinderFile<CR>
map <S-F6> :FuzzyFinderTag<CR>

" Execute file within vim
nmap <F12> :call ExecFile()<Enter>

" Surround visual selection with <p> </p> if surround_tag is not defined
if !exists("surround_tag")
    let surround_tag = 'p'
endif

vnoremap <F4> :call Surround('<' . surround_tag . '>', '</' . surround_tag . '>')<CR>

" A quick way to comment lines with the feraltogglecommentify.vim plugin
map <C-c> :TC<CR>j

" Switch to the previous buffer
map <F9> :b!#<Enter>

" Control-s seems to be universal for saving files
" and also quicker than :w<enter>
map <C-s> :w<enter>

" Switch to next same filetype buffer
nmap <Leader><Tab> :BufNextSameFT<Enter>

" Switch to previous same filetype buffer
nmap <Leader><S-Tab> :BufPrevSameFT<Enter>

" Switch to the next buffer
nmap <Tab> :bn<Enter>

" Switch to the previous buffer
nmap <S-Tab> :bp<Enter>

" Quicker way to delete a buffer
map <del> :bd<Enter>

" Press {{, ((, [[ and it will insert the corresponding {, (, [
inoremap {{ {<cr>}<esc>kA<cr>
inoremap (( ()<esc>i
inoremap [[ []<esc>i

" Opens lynx and search php.net for the word under the cursor
nmap  :!lynx -accept_all_cookies http://fr2.php.net/\#function.<CR>

" Cycles through function definition in a the current file
map ff /function <Enter>z<Enter>$
" }}}

" Useful abbrevs {{{
iab daylimotion dailymotion
iab flase false
iab lfase false
ab xr print_r($
ab xv var_dump($
ab xe error_log(
ab cl console.log(
ab fu function
ab xhtml <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"<CR>"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><CR><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr"><CR><head><CR><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><CR><title></title><CR></head><CR><body><CR></body><CR></html>

ab xhtmlxml <?php echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"; ?><CR><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"<CR>"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"><CR><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr"><CR><head><CR><title></title><CR></head><CR><body><CR></body><CR></html>

ab html401 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"<CR>"http://www.w3.org/TR/html4/strict.dtd"><CR><html><CR><head><CR><title></title><CR></head><CR><body></body><CR></html>

ab xcss <style type="text/css"><CR>/* <![CDATA[ */<CR><CR>/* ]]> */<CR></style>
ab xjs <script type="text/javascript"><CR>/* <![CDATA[ */<CR><CR>/* ]]> */<CR></script>
ab xlinkcss <link rel="stylesheet" href="" />
ab xlinkjs <script type="text/javascript" src=""></script>

ab xborder border: 1px solid red;
ab xback background-color: blue;<CR>opacity: 0.8;
ab xbgimg background: #000 url() top left;
ab ftext <input type="text" name="" value="" />
ab ffile <input type="file" name="" value="" />
ab fpassword <input type="password" name="" value="" />
ab fradio <input type="radio" name="" value="" />
ab fcheckbox <input type="checkbox" name="" value="" />
ab fsubmit <input type="submit" value="Valider" />
ab fbutton <input type="button" value="" />
ab ftextarea <textarea cols="20" rows="20" name=""><CR></textarea>
ab fselect <select name=""><CR><Tab><option value=""></option><CR></select>
ab fform <form action="" method="post" enctype="multipart/form-data">
ab xhref <a href=""<CR><TAB><TAB>onclick="window.open(this.href); return false;"></a>
ab xflash <object type="application/x-shockwave-flash" id="f" data="/flash/home.swf"><CR><param name="movie" value="/flash/home.swf" /><CR><param name="quality" value="high" /><CR><param name="bgcolor" value="#ffffff" /><CR></object>
ab xobject <object type="application/x-oleobject" width="284" height="236" data=""><CR><param name="movie" value="" /><CR><param name="quality" value="high" /><CR><param name="bgcolor" value="#000000" /><CR><embed type="video/x-ms-asf-plugin" width="284" height="236" pluginspage="http://www.microsoft.com/Windows/Downloads/Contents/Products/MediaPlayer/" src="" name="MediaPlayer" ShowStatusBar="0" ShowControls="0"></embed><CR></object>
ab dlm dailymotion
" }}}

" Plugin configuration {{{

" project
nmap <silent> <Leader>p :Project<CR>

" php doc
nnoremap <C-P> :call PhpDocSingle()<CR>

"This variable, if set to a non-zero value, causes the temporary result buffers
"to automatically delete themselves when hidden.
let VCSCommandDeleteOnHide = 1

"This variable controls whether the original buffer is replaced ('edit') or
"split ('split').  If not set, it defaults to 'split'.
let VCSCommandEdit = 1

" matchit
filetype plugin on

" minibuf
"let loaded_minibufexplorer = 1 " desactivate minibufexplorer
let g:miniBufExplUseSingleClick = 1
"let g:miniBufExplVSplit = 1
"let g:miniBufExplMinSize = 20
"let g:miniBufExplMaxSize =25 

" Taglist
let g:Tlist_Use_Horiz_Window = 0
let g:Tlist_Use_Right_Window = 1
let Tlist_Auto_Highlight_Tag = 0
let Tlist_Auto_Open = 0
let Tlist_Show_One_File = 1
let Tlist_Sort_Type = 'name'
"let Tlist_Ctags_Cmd = "~/bin/ctags"
" Actionscript language
" put this in ~/.ctags
"--langdef=actionscript
"--langmap=actionscript:.as
"--regex-actionscript=/^[ \t]*[(private| public|static) ( \t)]*function[ \t]+([A-Za-z0-9_]+)[ \t]*\(/\1/f, function, functions/
"--regex-actionscript=/^[ \t]*[(public) ( \t)]*function[ \t]+(set|get) [ \t]+([A-Za-z0-9_]+)[ \t]*\(/\1 \2/p,property, properties/
"--regex-actionscript=/^[ \t]*[(private| public|static) ( \t)]*var[ \t]+([A-Za-z0-9_]+)[ \t]*/\1/v,variable, variables/
"--regex-actionscript=/.*\.prototype \.([A-Za-z0-9 ]+)=([ \t]?)function( [ \t]?)*\(/\1/ f,function, functions/
"--regex-actionscript=/^[ \t]*class[ \t]+([A-Za-z0-9_]+)[ \t]*/\1/c,class, classes/
let tlist_actionscript_settings = 'actionscript;c:class;f:method;p:property;v:variable'

" FuzzyFinder
let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{},
\                      'MruFile':{}, 'MruCmd':{}, 'Bookmark':{},
\                      'Tag':{}, 'TaggedFile':{},
\                      'GivenFile':{}, 'GivenDir':{}, 'GivenCmd':{},
\                      'CallbackFile':{}, 'CallbackItem':{}, }

let g:FuzzyFinderOptions.Base.ignore_case = 1
let g:FuzzyFinderOptions.Base.min_length = 3
let g:FuzzyFinderOptions.File.excluded_path = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|\.git$|gen'
let g:FuzzyFinderOptions.Base.abbrev_map  = { 
\            "DM" : [
\                "~/dailymotion/css/",
\                "~/dailymotion/css/**/",
\                "~/dailymotion/js/",
\                "~/dailymotion/js/**/",
\                "~/dailymotion/lib/",
\                "~/dailymotion/lib/**/",
\            ],
\            "MY" : [
\                "/var/www/myzf/application/",
\                "/var/www/myzf/application/**/",
\                "/var/www/myzf/library/Model/",
\                "/var/www/myzf/library/Model/**/",
\            ],
\}

" }}}

" User functions {{{
fun! Surround(s1, s2) range
  exe "normal vgvmboma\<ESC>"
  normal `a
  let lineA = line(".")
  let columnA = col(".")

  normal `b
  let lineB = line(".")
  let columnB = col(".")
  "exchange marks
  if lineA > lineB || lineA <= lineB && columnA > columnB
    " save b in c
    normal mc
    " store a in b
    normal `amb
    " set a to old b
    normal `cma
  endif

  exe "normal `ba" . a:s2 . "\<ESC>`ai" . a:s1 . "\<ESC>"
endfun 

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

function! ToggleHLSearch()
    if &hls
        set nohls
    else
        set hls
    endif
endfunction

"Get the next or previous buffer which matches pattern,
"wraps around end/start.
func! IncrBufFiltered(pat, decr)
  let fblist =
    \ filter(range(1, bufnr('$')),
    \ 'buflisted(v:val) && bufname(v:val) =~ a:pat')

  if empty(fblist) || len(fblist) <= 1
    return bufnr('%')
  endif
  if a:decr == 1
    let fblist = reverse(fblist)
  endif

  let key = index(fblist, bufnr('%')) + 1

  if key >= len(fblist)
    let key = 0
  endif

  return fblist[key]
endfun

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
  "echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echo getline(search("?private\\|public\\|protected\\|procedure\\|function\\s\\+\.*(", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map <Leader>f :call ShowFuncName()<CR>

function! ToggleScratch()
  if expand('%') == g:ScratchBufferName
    quit
  else
    Sscratch
  endif
endfunction
map <Leader>s :call ToggleScratch()<CR>
" }}}

" User commands or aliases
command! BufNextSameFT exe "bu " . IncrBufFiltered('\.' . expand('%:e') . '$', 0)
command! BufPrevSameFT exe "bu " . IncrBufFiltered('\.' . expand('%:e') . '$', 1)
