" set implementation from https://vi.stackexchange.com/a/19232

" number of elements in set
function! s:len() dict
    return len(self.dict)
endfunction

" adds element to set
" returns 1 if element was added, 0 if it was already present
function! s:add(element) dict
    if ! has_key(self.dict, a:element)
        let self.dict[a:element] = 1
        return 1
    else
        return 0
    endif
endfunction

" returns 1 if element is contained in set
function! s:contains(element) dict
    return has_key(self.dict, a:element)
endfunction

" removes element from set
" returns 1 if element was removed, 0 if it was not present
function! s:remove(element) dict
    if(self.contains(a:element))
        call remove(self.dict, a:element)
        return 1
    else
        return 0
    endif
endfunction

" returns content as list
function! s:as_list() dict
    return keys(self.dict)
endfunction

function! NewSet()
    let newSet = {'dict': {},
                \ 'len': function("s:len"),
                \ 'add': function("s:add"),
                \ 'contains': function("s:contains"),
                \ 'remove': function("s:remove"),
                \ 'as_list': function("s:as_list"),
                \ }
    return newSet
endfunction
