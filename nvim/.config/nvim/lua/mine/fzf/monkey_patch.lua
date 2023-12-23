local fzf_defaults = require('fzf-lua.defaults').defaults
fzf_defaults.grep.rg_opts = fzf_defaults.grep.rg_opts .. " --hidden -e"
fzf_defaults.files.fd_opts = fzf_defaults.files.fd_opts .. " --strip-cwd-prefix"
