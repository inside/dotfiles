function! mouse#toggleActive()
  if &mouse ==# "nv"
    set mouse=
    echo "Mouse is off"
  else
    set mouse=nv
    echo "Mouse is on"
  endif
endfunction

