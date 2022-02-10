" FIXME: doing both `echo` and `echom` is wrong so removed it
" for eg. use `g<` command with old code or
" use `Redir Blame` either in normal mode or in visual mode 
" with old code
function! s:Blame(line1, line2, bang) abort
  if &modified && !a:bang
    echohl ErrorMsg
    " TODO: it is possible to do blame on an unsaved file in Fugitive
    echo "Can't blame properly on an unsaved file, use `Blame!` to do it anyway"
    echohl None
    return
  endif

  let l:lines = a:line1 . ',' . a:line2
  let l:msgs =  systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L " . l:lines  . " " . expand('%:t'))
  let l:msgs_to_show = []

  for msg in msgs
    let l:msgs_to_show += [msg . "\n^^^^^^^^ " . s:get_log_message(msg)]
  endfor

  echo join(l:msgs_to_show, "\n")
endfunction

" from https://gist.github.com/romainl/5b827f4aafa7ee29bdc70282ecc31640
command! -range -bang Blame call <sid>Blame(<line1>, <line2>, <bang>0)

