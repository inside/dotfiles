" vim: ts=2 sw=2 et fdm=marker
" Plugin: sessions.vim --- named shortcuts to groups of files
" Version: 0.2
" $Id: sessions.vim,v 1.28 2003/10/09 16:35:06 andrew Exp andrew $
"
" Author: Andrew Rodionoff <arnost AT mail DOT ru>
"
" Description: This plugin introduces following additions to regular session
" management (see help on viminfo, mkview, mksession):
" - short commands for session saving, loading, clearing and merging:
"   :SS <name> --- save session <name>
"   :SL <name> --- load session <name>
"   :SN <name> --- clear buffer list and set new current session name.
"   :SM <name> --- merge session <name> into current one.
"   :SS without parameter saves current session loaded with :SL or created
"       with SN.
"   :SL or :SM without a parameter open most recently used session list,
"       sorted by access time.
"
"
" - All sessions are stored and loaded out of specific directory named
"   'sessions' in &runtimepath. 
"   Note: it is nessessary to create this directory manually before using
"   plugin. E.g. 'mkdir -p ~/.vim/sessions' will do on Unix-like systems.
"
" - Session name argument does not need to have path prefix or extension. It's
"   also may be completed from already saved session names.
"
" - Major difference to built-in session mechanism is that saved session by
"   default does not contain any mapping, window layout, line number or
"   unlisted buffer information whatsoever. There's just file list and current
"   working directory/file. This is done intentionally, with robustness and
"   loading speed in mind (see help on viminfo to learn how to store file
"   marks across sessions). The only exception so far is 'fileencoding' local
"   option which is stored in minisession since version 0.2. This allows to
"   have different non-default encodings in file group. To enable old-stype
"   session files, set variable g:Sessions_Old_style = 1 in your .vimrc.
"
" New in version 0.2:
" - If file buffer has non-empty 'fileencoding' option, its value stored in
"   mini-session, thus allowing explicitly set fileencodings to be persistent
"   across sessions.
"
" - :SL or :SM without argument invoke MRU-session menu.
"
" TODO:
" - More persistent file-local options in minisessions?
"
" Set g:Sessions_Old_style to 1 if you want traditional session files
if !exists('g:Sessions_Old_style')
  let g:Sessions_Old_style = 0
endif

fun! s:Head(str)
  return substitute(a:str, '\([^\n]*\)\(\n.*\|$\)', '\1', '')
endfun

fun! s:Tail(str)
  return substitute(a:str, '[^\n]*\n\?\(.*\)', '\1', '')
endfun

fun! s:Zap()
  let l:bnr = 1
  while l:bnr <= bufnr('$')
    if buflisted(l:bnr) && bufname(l:bnr) != ""
      silent! exec 'bw! ' . l:bnr
    endif
    let l:bnr = l:bnr + 1
  endwhile
endfun

fun! s:WeedEmpty()
  let l:bnr = 1
  while l:bnr <= bufnr('$')
    if buflisted(l:bnr) && bufname(l:bnr) == ""
      silent! exec 'bw! ' . l:bnr
    endif
    let l:bnr = l:bnr + 1
  endwhile
endfun

fun! s:Source(name)
  let l:sesspath = globpath(&rtp, 'sessions/' . escape(a:name, ' ') . '.vim')
  if l:sesspath != ""
    let l:name = s:Head(l:sesspath)
    let l:time = localtime()
    exec 'redir! > ' . fnamemodify(l:name, ':r').'.mru'
    silent echo 'call SessionMRUInsert(' . l:time . ', "' .
          \ escape(a:name, ' "') . '")'
    redir END
    exe 'so ' . l:name
  endif
endfun

fun! SessionMRUInsert(n, name)
  let l:sesstr = "[" . strftime('%c', a:n) . "]\t". a:name .  "\t" . a:n
  let l:bottom = line('$')
  let l:inspoint = 1
  while l:inspoint <= l:bottom
    let l:line = getline(l:inspoint)
    let l:cutpos = strridx(l:line, "\t")
    if l:cutpos != -1
      let l:date = strpart(l:line, l:cutpos + 1)
      if l:date < a:n
        break
      endif
    endif
    let l:inspoint = l:inspoint + 1
  endwhile
  silent exec (l:inspoint - 1) . 'put =l:sesstr'
endfun

fun! s:Enter()
  let l:line = getline('.')
  let l:c1 = stridx(l:line, "\t")
  let l:c2 = strridx(l:line, "\t")
  if l:c1 < l:c2 && l:c2 != -1
    let l:sessname = strpart(l:line, l:c1+1, l:c2 - l:c1 - 1)
    let l:mode = b:mode
    close
    if l:mode
      exec 'SL ' . escape(l:sessname, ' ')
    else
      exec 'SM ' . escape(l:sessname, ' ')
    endif
  endif
endfun


fun! s:MRU(mode)
  if bufwinnr('##Sessions-MRU##') != -1
    exe bufwinnr('##Sessions-MRU##') . 'wincmd w'
  else
    split \#\#Sessions-MRU\#\#
    syn match Statement "^[^\t]*"
    syn match Type "\t[^\t]*"
    syn match Ignore "\t[0-9]*$"
    map <buffer> <CR> :call <SID>Enter()<CR>
    aug SESSIONS_MRU
      au!
      au WinLeave \#\#Sessions-MRU\#\# :bwipe
    aug END
  endif
  let b:mode = a:mode
  setlocal modifiable bufhidden=wipe nobuflisted
  silent 1,$d _
  runtime! sessions/*.mru
  silent 1d _
  let l:maxheight = winheight(0)
  if l:maxheight > line('$')
    silent exec line('$') . 'wincmd _'
  endif
  setlocal nomodifiable nomodified
endfun

fun! s:Load(...)
  if a:0
    wall!
    call s:Zap()
    call s:Source(a:1)
    call s:WeedEmpty()
  else
    call s:MRU(1)
  endif
endfun

fun! s:Merge(...)
  if a:0
    let l:old_ts = v:this_session
    call s:Source(a:1)
    let v:this_session = l:old_ts
  else
    call s:MRU(0)
  endif
endfun

fun! s:Make(fname)
  if g:Sessions_Old_style
    exec "mksession! " . a:fname
    return
  endif
  exec "redir! > " . a:fname
  silent echo 'augroup SESSIONS'
  silent echo 'au! '
  silent echo 'cd ' . getcwd()
  let l:bnr = 1
  while l:bnr <= bufnr('$')
    if buflisted(l:bnr) && bufname(l:bnr) != ""
      silent echo 'badd ' . escape(fnamemodify(bufname(l:bnr), '%:~:.'), '" ')
      if getbufvar(l:bnr, '&fenc') != ""
        silent echo 'au BufReadPost ' . 
              \ escape(fnamemodify(bufname(l:bnr), '%:~:.'), '" ') .
              \ ' setlocal fenc=' . getbufvar(l:bnr, '&fenc') .
              \ ' | au! SESSIONS BufReadPost ' .
              \ escape(fnamemodify(bufname(l:bnr), '%:~:.'), '" ')
      endif
    endif
    let l:bnr = l:bnr + 1
  endwhile
  silent echo 'augroup END'
  silent echo 'edit ' . expand('%:~:.')
  silent echo 'let v:this_session = "' . escape(a:fname, '"\') . '"'
  redir END
  let v:this_session = a:fname
endfun

fun! s:Save(...)
  wall
  if a:0 == 0
    if v:this_session != ""
      call s:Make(v:this_session)
    else
      echo "No current session to write"
    endif
  else
    let l:sessdirs = globpath(&rtp, 'sessions')
    if l:sessdirs == ""
      echoerr "Sessions directory not found."
      return
    endif
    while l:sessdirs != ""
      let l:sessdest = s:Head(l:sessdirs)
      if filewritable(l:sessdest) == 2
        call s:Make(l:sessdest . '/' . a:1 . '.vim')
        break
      endif
      let l:sessdirs = s:Tail(l:sessdirs)
    endwhile
  endif
endfun

fun! s:New(...)
  wall
  if a:0 == 0
    let v:this_session = ''
  else
    let v:this_session = a:1
  endif
  call s:Zap()
endfun

fun! SessionComplete(A,L,P)
  return substitute(globpath(&rtp, 'sessions/*.vim'), '.\{-}\([^/\n]\+\).vim\(\n\|$\)', '\1\2', 'g')
endfun

command! -complete=custom,SessionComplete -nargs=? SL call <SID>Load(<f-args>)
command! -complete=custom,SessionComplete -nargs=? SM call <SID>Merge(<f-args>)
command! -complete=custom,SessionComplete -nargs=? SS call <SID>Save(<f-args>)
command! -complete=custom,SessionComplete -nargs=? SN call <SID>New(<f-args>)
