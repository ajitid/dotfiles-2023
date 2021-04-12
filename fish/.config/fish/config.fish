# cd ~
if status is-interactive
	cd $HOME
end
# starship init fish | source
# use `eval (ssh-agent -c)` or github.com/danhper/fish-ssh-agent

# export PATH="$PATH:/mnt/c/Windows/System32"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"

abbr setclip "xclip -selection c"
abbr getclip "xclip -selection c -o"

alias l='ls  -alhp --group-directories-first --color=never'

function mkcd --description 'Create and enter directory'
	if mkdir $argv
		if string match -qv -- '-*' $argv[-1]
			cd $argv[-1]
		end
	end
end

# set -gx VOLTA_HOME "$HOME/.volta"
# set -gx PATH "$VOLTA_HOME/bin" $PATH

# remove Windows from PATH
# see https://github.com/microsoft/WSL/issues/1493#issuecomment-797575704
set PATH (/usr/bin/printenv PATH | /usr/bin/perl -ne 'print join(":", grep { !/\/mnt\/[a-z]/ } split(/:/));')

export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$HOME/miniconda3/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/zlksnk/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

export DISPLAY=(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=0

alias v "~/work/nvim.appimage"
alias g "/usr/bin/smerge"

set -x N_PREFIX "$HOME/n"; contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

