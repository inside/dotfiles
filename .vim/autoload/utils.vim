" Helper to create aliases for vim commands.
" Thanks to
" http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
function! utils#alias(alias, cmd)
  execute
        \ printf('cnoreabbrev %s ', a:alias) .
        \ '<c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? ' .
        \ printf('"%s" : "%s"<cr>', a:cmd, a:alias)
endfunction

function! utils#prepageCommitMessage()
  let file_head = expand('%:p:h')

  if !filereadable(file_head . '/MERGE_MSG') &&
        \ !filereadable(file_head . '/SQUASH_MSG')
    startinsert
  endif
endfunction

function! utils#nextTextObject(motion, dir)
  let text_object = nr2char(getchar())

  if text_object ==# 'b'
    let text_object = '('
  elseif text_object ==# 'B'
    let text_object = '{'
  elseif text_object ==# 'm'
    let text_object = '['
  endif

  execute 'normal! ' . a:dir . text_object . 'v' . a:motion . text_object
endfunction

function! utils#setIndentSize(spaces)
  if type(str2nr(a:spaces)) != 0
    return
  endif

  execute 'setlocal shiftwidth=' . a:spaces
  execute 'setlocal softtabstop=' . a:spaces
  execute 'setlocal tabstop=' . a:spaces
endfunction

" requires https://github.com/godlygeek/windowlayout
function! utils#undoCloseTab()
  if exists("s:layout") && !empty(s:layout)
    tabnew
    call windowlayout#SetLayout(s:layout)
    unlet s:layout
  endif
endfunction

function! utils#closeTab()
  let s:layout = windowlayout#GetLayout()
  tabclose
endfunction

function! utils#lineMotion(dir)
  if v:count == 0
    return 'g' . a:dir
  endif
  return ":\<C-u>normal! m'" . v:count . a:dir . "\<CR>"
endfunction

" Toggles the quickfix window open or close
" The quickfix-reflector.vim plugin is needed for this to work
" because it sets the quickfix buffer name to quickfix-reflector-n (n being a
" number)
function! utils#quickfixToggle()
  let qf_name = bufname('quickfix-reflector')

  " The quickfix is not in the buffer list or not visible, let's open it
  if qf_name ==# '' || bufwinnr(qf_name) == -1
    copen
  " The quickfix is visible, let's close it
  else
    cclose
  endif
endfunc
