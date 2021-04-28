let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'always'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true

inoremap <silent><expr> <C-Space> compe#complete()
" Taken from https://github.com/hrsh7th/nvim-compe/issues/106 (also present in
" compe docs) 
" there is more for cohama/lexima.vim ->
" https://github.com/hrsh7th/nvim-compe/issues/121
inoremap <silent><expr> <CR>      compe#confirm({'keys': "\<Plug>delimitMateCR", 'mode': ''})
inoremap <silent><expr> <C-e>     compe#close('<C-e>')

" inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
" removed as <c-d> is used for de-indent in insert mode
" inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" vsnip location
let g:vsnip_snippet_dir = expand('~/nvimfiles/snips')
imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
