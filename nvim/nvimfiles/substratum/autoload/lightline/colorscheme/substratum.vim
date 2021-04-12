let s:base02 = [ '#050505', 236 ]
let s:base01 = [ '#050505', 239 ]
let s:yellow = [ '#0f0f0f', 215 ]
let s:red = [ '#0f0f0f', 167 ]

let s:bg = ['#20222d', '236']
let s:fg = ['#b5b4c9', '236']
let s:fg_fade = ['#6c6f82', '236']

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.normal.middle = copy(s:p.normal.left)
let s:p.normal.right = copy(s:p.normal.left)

let s:p.inactive.right = [ [ s:fg_fade, s:bg ], [ s:fg_fade, s:bg ] ]
let s:p.inactive.left =  copy(s:p.inactive.right)
let s:p.inactive.middle = copy(s:p.inactive.right)

let s:p.tabline.left = copy(s:p.inactive.right)
let s:p.tabline.tabsel = copy(s:p.normal.left)
let s:p.tabline.right = copy(s:p.inactive.right)

let s:p.normal.error = [ [ s:red, s:base02 ] ]
let s:p.normal.warning = [ [ s:yellow, s:base01 ] ]

let g:lightline#colorscheme#substratum#palette = lightline#colorscheme#flatten(s:p)
