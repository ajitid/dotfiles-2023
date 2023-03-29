" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

" ErrCheck calls 'errcheck' for the given packages. Any warnings are populated in
" the location list
function! go#lint#Errcheck(bang, ...) abort
  call go#cmd#autowrite()


  let l:cmd = [go#config#ErrcheckBin(), '-abspath']


  let buildtags = go#config#BuildTags()
  if buildtags isnot ''
    let l:cmd += ['-tags', buildtags]
  endif


  if a:0 == 0
    let l:import_path = go#package#ImportPath()
    if l:import_path == -1
      call go#util#EchoError('could not determine package')
      return
    endif
    let l:cmd = add(l:cmd, l:import_path)
  else
    let l:cmd = extend(l:cmd, a:000)
  endif


  let l:type = 'errcheck'
  if go#config#EchoCommandInfo()
    call go#util#EchoProgress(printf('[%s] analyzing...', l:type))
  endif
  let l:status = {
        \ 'desc': 'current status',
        \ 'type': l:type,
        \ 'state': "started",
        \ }
  redraw


  let [l:out, l:err] = go#util#ExecInDir(l:cmd)


  let l:status.state = 'success'
  let l:state = 'PASS'


  let l:listtype = go#list#Type("GoErrCheck")
  if l:err != 0
    let l:status.state = 'failed'
    let l:state = 'FAIL'


    let l:winid = win_getid(winnr())


    if l:err == 1
      let l:errformat = "%f:%l:%c:\ %m,%f:%l:%c\ %#%m"
      " Parse and populate our location list
      call go#list#ParseFormat(l:listtype, l:errformat, split(out, "\n"), 'Errcheck', 0)
    endif


    let l:errors = go#list#Get(l:listtype)
    if empty(l:errors)
      call go#util#EchoError(l:out)
      return
    endif


    if !empty(errors)
      call go#list#Populate(l:listtype, l:errors, 'Errcheck')
      call go#list#Window(l:listtype, len(l:errors))
      if !a:bang
        call go#list#JumpToFirst(l:listtype)
      else
        call win_gotoid(l:winid)
      endif
    endif
    if go#config#EchoCommandInfo()
      call go#util#EchoError(printf('[%s] %s', l:type, l:state))
    endif
  else
    call go#list#Clean(l:listtype)
    if go#config#EchoCommandInfo()
      call go#util#EchoSuccess(printf('[%s] %s', l:type, l:state))
    endif
  endif
endfunction
