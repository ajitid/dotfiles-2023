https://stackoverflow.com/questions/59991626/creating-a-vscode-snippet-to-capitalize-a-duplicate-tabstop-inside-a-placehold
https://code.visualstudio.com/docs/editor/userdefinedsnippets#_grammar
just make a stack overflow search vscode snippet `<query>`

// below is for `export default SomeComponent`
// "export default ${1:${TM_FILENAME_BASE/(?:^|-)([a-z])|/${1:/upcase}/g}}"

https://github.com/tpope/vim-abolish/issues/90
"body": "const [${1}, set${1/(.*)/${1:/capitalize}/}] = useState(${3})",
