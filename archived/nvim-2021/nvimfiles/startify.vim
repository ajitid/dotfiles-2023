" -----------------------
"  vim-startify Settings
" -----------------------

" Number of spaces for left padding
let g:startify_padding_left = 4

" List of sections in the start menu
let g:startify_lists = [                                                  
      \ { 'type': 'dir',       'header': ['    Recently Opened']},
      \ { 'type': 'bookmarks', 'header': ['    Bookmarks']      },
      \ { 'type': 'sessions',  'header': ['    Sessions']       },        
      \ { 'type': 'commands',  'header': ['    Commands']       },
      \ ]   

" List of commands
let g:startify_commands = [
      \ {'h': ['Check health',':checkhealth']},
      \ {'p': ['Install plugins', ':PlugInstall']},
      \ {'c': ['Clean plugins', ':PlugClean']},
      \ {'u': ['Update plugins', ':PlugUpdate']},
      \ ]

" Number of files to list
let g:startify_files_number = 5

" Changing directory is handled by vim-rooter
let g:startify_change_to_dir = 0

" Header
function! s:center(lines) abort
  let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
  let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
  return centered_lines
endfunction

" let g:startify_custom_header = s:center([
"     \ '    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
"     \ '    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
"     \ '    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
"     \ '    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
"     \ '    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
"     \ '    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
"     \ 'fdsfds'
"     \ ]
"     \ + split(strftime('%n    DATE: %A, %d/%m/%y%n    TIME: %R'), '\n'))

" let g:startify_disable_at_vimenter = 1
" let g:startify_custom_header = [g:FindRootDirectory()]

