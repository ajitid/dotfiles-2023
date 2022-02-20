" https://github.com/tpope/vim-abolish/blob/master@%7B2021-04-13T07:02:16Z%7D/plugin/abolish.vim#L149
function! s:mixedcase(arg)
  let l:arg = copy(a:arg)
  return map(l:arg, 'g:Abolish.mixedcase(v:val)')
endfunction

function! s:uppercase(arg)
  let l:arg = copy(a:arg)
  return map(l:arg, 'g:Abolish.uppercase(v:val)')
endfunction

let s:bool = ['true', 'false']
let s:yesno = ['yes', 'no']
let s:onoff = ['on', 'off']
let s:updown = ['up', 'down']
let s:endis = ['enable', 'disable']
let s:endisd = ['enabled', 'disabled']

let g:CtrlXA_Toggles = [
    \ s:bool, s:mixedcase(s:bool) , s:uppercase(s:bool),
    \ s:yesno, s:mixedcase(s:yesno) , s:uppercase(s:yesno),
    \ s:onoff, s:mixedcase(s:onoff) , s:uppercase(s:onoff),
    \ s:updown, s:mixedcase(s:updown) , s:uppercase(s:updown),
    \ s:endis, s:mixedcase(s:endis) , s:uppercase(s:endis),
    \ s:endisd, s:mixedcase(s:endisd) , s:uppercase(s:endisd),
    \ ['&&', '||'],
    \ ['+', '-'], ['++', '--'],
    \ ['==', '!='],
    \ ['<', '>'], ['<=', '>='], ['>>', '<<'],
    \ ['max', 'min'], ['Max', 'Min'],
    \ ]

let g:CtrlXA_Toggles = [
    \ ['!==', '==='],
    \ ] + g:CtrlXA_Toggles

