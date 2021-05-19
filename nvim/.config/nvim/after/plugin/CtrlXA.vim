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

let g:CtrlXA_Toggles = [
    \ ['alpha', 'beta', 'gamma', 'delta', 'epsilon', 'zeta', 'eta', 'theta', 'iota', 'kappa', 'lambda', 'mu', 'nu', 'xi', 'omikron', 'pi', 'rho', 'sigma', 'tau', 'upsilon', 'phi', 'chi', 'psi', 'omega'],
    \ ['Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta', 'Eta', 'Theta', 'Iota', 'Kappa', 'Lambda', 'Mu', 'Nu', 'Xi', 'Omikron', 'Pi', 'Rho',  'Sigma', 'Tau', 'Upsilon', 'Phi', 'Chi', 'Psi', 'Omega'],
    \ s:bool, s:mixedcase(s:bool) , s:uppercase(s:bool),
    \ s:yesno, s:mixedcase(s:yesno) , s:uppercase(s:yesno),
    \ s:onoff, s:mixedcase(s:onoff) , s:uppercase(s:onoff),
    \ s:updown, s:mixedcase(s:updown) , s:uppercase(s:updown),
    \ ['set', 'unset'],
    \ ['is', 'isnot'] ,
    \ ['&&', '||'],
    \ ['+', '-'], ['++', '--'],
    \ ['==', '!='] , ['=~', '!~'],
    \ ['<', '>'], ['<=', '>='], ['>>', '<<'],
    \ ['verbose', 'debug', 'info', 'warn', 'error', 'fatal'],
    \ ['remote', 'local', 'base'], ['REMOTE', 'LOCAL', 'BASE'],
    \ ['ours', 'theirs'], ['Ours', 'Theirs'],
    \ ['enable', 'disable'], ['Enable', 'Disable'],
    \ ['enabled', 'disabled'], ['Enabled', 'Disabled'],
    \ ['max', 'min'], ['Max', 'Min'],
    \ ]

let g:CtrlXA_Toggles = [
    \ ['!==', '==='],
    \ ] + g:CtrlXA_Toggles
