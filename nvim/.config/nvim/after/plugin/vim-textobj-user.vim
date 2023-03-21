" same chars present at start and end won't work, but there's a workaround,
" see https://github.com/kana/vim-textobj-user/issues/48
" the underscore example here will make the most sense https://github.com/kana/vim-textobj-user/issues/48#issuecomment-218425911
" but making it for forward slashes that regex too complicated,
" so we'll use this instead https://old.reddit.com/r/vim/comments/11x509x/how_to_change_between_slashes_using_vimtextobjuser/jd1sol1/
" rest I really don't need and incl. them would mean i'd have to remember too many options
for char in [ '<bar>', '/' ]
  execute 'xnoremap i' . char . ' :<c-u>normal! T' . char . 'vt' . char . '<cr>'
  execute 'onoremap i' . char . ' :normal vi' . char . '<cr>'
  execute 'xnoremap a' . char . ' :<c-u>normal! F' . char . 'vf' . char . '<cr>'
  execute 'onoremap a' . char . ' :normal va' . char . '<cr>'
endfor

