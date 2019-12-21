" Lowercase inner word
function! case#lowerInnerWord()
  let col = virtcol('.')
  execute 'normal guiw'
  execute 'normal ' . col . '|'
endfunction

function! case#upperInnerWord()
  let col = virtcol('.')
  execute 'normal gUiw'
  execute 'normal ' . col . '|'
endfunction

" Toggle capitalize inner word
function! case#toggleCapitalizeInnerWord()
  let col = virtcol('.')

  execute 'normal b~'
  execute 'normal ' . col . '|'
endfunction
