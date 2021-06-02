let g:quickswitch = {}

function! s:parse_json(string) abort
  let string = type(a:string) == type([]) ? join(a:string, ' ') : a:string
  if exists('*json_decode')
    try
      return json_decode(string)
    catch
    endtry
  else
    let [null, false, true] = ['', 0, 1]
    let stripped = substitute(string, '\C"\(\\.\|[^"\\]\)*"', '', 'g')
    if stripped !~# "[^,:{}\\[\\]0-9.\\-+Eaeflnr-u \n\r\t]"
      try
        return eval(substitute(string, "[\r\n]", ' ', 'g'))
      catch
      endtry
    endif
  endif
  throw "invalid JSON: ".string
endfunction

function! QuickSwitchInitialize() abort
  let g:quickswitch = {}
  let l:configfilename = '.quickswitch.json'
  if !filereadable(l:configfilename) 
    return
  endif

  let l:contents = readfile(l:configfilename)
  try
    let g:quickswitch = s:parse_json(l:contents)
  catch /^invalid JSON:/
    echohl Error
    echom 'Invalid JSON provided for `.quickswitch.json`'
    echohl None
  endtry
endfunction

function StartsWith(big, small)
  return a:big[0:len(a:small)-1] ==# a:small
endfunction

function! QuickSwitch(mapname, filename, mode = v:null) abort
  let l:found = 0
  for [key, value] in items(g:quickswitch)
    for test in split(key, '|')
      if StartsWith(expand('%'), test)
        let l:found = 1
        try
          let l:mapvalue = value[a:mapname]
          let l:filepath = substitute(l:mapvalue, '*', a:filename, 'g')
          let l:open_using = a:mode == v:null ? 'e' : a:mode
          exec(l:open_using . ' ' . l:filepath)
        catch /E716/
          echohl Error
          echo '"' . a:mapname . '"' . ' ' . 'key does not exist'
          echohl None
        endtry
        break
      endif
    endfor
  endfor

  if l:found == 0
    echohl Error
      echo "No mapping found for this file"
    echohl None
  endif
endfunction

" TODO: add completion support like test, source, etc. and when 716 is catched
" list other keys
