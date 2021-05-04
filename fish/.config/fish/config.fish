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

alias v "~/workspace/execs/nvim.appimage"
# see for info https://github.com/mhinz/neovim-remote/
# and https://thoughtbot.com/upcase/videos/neovim-remote-as-preferred-editor
alias vr "NVIM_LISTEN_ADDRESS=/tmp/nvimsocket ~/workspace/execs/nvim.appimage"

export PATH="$PATH:$HOME/workspace/execs"
alias g "/usr/bin/smerge"

set -x N_PREFIX "$HOME/n"; contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

begin
  set --local AUTOJUMP_PATH $HOME/.autojump/share/autojump/autojump.fish
  if test -e $AUTOJUMP_PATH
    source $AUTOJUMP_PATH
  end
end

function up
  # set args (getopt -s sh abc: $argv); or help_exit
  # echo $argv[1]
  set -l dir_to_be_child $argv[1]
  # intentionally written this way because I'm learning syntax
  # https://stackoverflow.com/a/29177261/7683365
  if [ "$dir_to_be_child" = "" ]
    cd ..
  else
    cd -
    set -l alt_dir $PWD
    cd -
    set -l curr_dir $PWD
    set -l is_found 0
    while [ "$PWD" != "/" ]; and test $is_found -eq 0
      cd ..
      set -l res (find $dir_to_be_child -maxdepth 0 -type d | wc -l)
      if test $res -eq 1
        set is_found 1
      end
    end
    if [ "$PWD" = "/" ]
      cd $alt_dir
      cd $curr_dir
      echo "Couldn't find $dir_to_be_child"
    else
      set -l found_dir $PWD
      cd $curr_dir
      cd $found_dir
    end
  end
end
