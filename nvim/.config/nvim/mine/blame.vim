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

" https://github.com/tommcdo/vim-fugitive-blame-ext/blob/master/plugin/fugitive-blame-ext.vim
function! s:log_message(commit)
  if a:commit =~ '^0\+$'
    return '(Not Committed Yet)'
  endif

  if !has_key(s:log_messages, a:commit)
    let cmd_output = system('git show --no-show-signature --oneline '.a:commit)
    let first_line = split(cmd_output, '\n')[0]
    let s:log_messages[a:commit] = substitute(first_line, '[a-z0-9]\+ ', '', '')
  endif

  return s:log_messages[a:commit]
endfunction

function! s:truncate_message(message)
  let offset = 2

  if &ruler == 1 && (&laststatus == 0 || (&laststatus == 1 && winnr('$') == 1))
    " Statusline is not visible, so the ruler is. Its width is either 17
    " (default) or defined in 'rulerformat'.
    let offset += str2nr(get(matchlist(&rulerformat, '^%\(\d\+\)('), 1, '17')) + 1
  endif

  if &showcmd
    " Width of showcmd seems to always be 11.
    let offset += 11
  endif

  let maxwidth = &columns - offset

  if strlen(a:message) > maxwidth
    return a:message[0:(maxwidth - 3)] . '...'
  else
    return a:message
  endif
endfunction

function! s:get_log_message(blameline)
  let line = substitute(a:blameline, '\v^\^?([a-z0-9]+).*$', '\1', '')
  redraw
  return s:truncate_message(s:log_message(line))
endfunction

function! s:show_log_message_for_line()
  echo s:get_log_message(getline('.'))
endfunction

let s:log_messages = {}

" requires commit hash to be at start of line
command! EchoLogMessage call <sid>show_log_message_for_line()

