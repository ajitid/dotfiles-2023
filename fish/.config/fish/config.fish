# cd ~
if status is-interactive
	cd $HOME
end
# starship init fish | source
# use `eval (ssh-agent -c)` or github.com/danhper/fish-ssh-agent

# export PATH="$PATH:/mnt/c/Windows/System32"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/workspace/scripts"

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

# TODO add completion
function up
  # set args (getopt -s sh abc: $argv); or help_exit
  # echo $argv[1]
  set -l dir_to_be_child $argv[1]
  # intentionally written this way because I'm learning syntax
  # https://stackoverflow.com/a/29177261/7683365
  if [ "$dir_to_be_child" = "" ]
    cd .. # in fish you can do `..` directly, and for cd-ing into a child dir we can use `src/` or `./src/`
  else
    cd -
    set -l alt_dir $PWD
    cd -
    set -l curr_dir $PWD

    set -l is_found 0
    while [ "$PWD" != "/" ]; and test $is_found -eq 0
      cd ..
      # https://www.unix.com/shell-programming-and-scripting/46716-execute-command-silently-quietly-within-shell.html
      set -l res (find $dir_to_be_child -maxdepth 0 -type d 2>/dev/null | wc -l)
      if test $res -eq 1
        set is_found 1
      end
    end

    if [ "$PWD" = "/" ]
      cd $alt_dir
      cd $curr_dir
      echo "Couldn't find $dir_to_be_child"
      return 1
    end

    set -l found_dir $PWD
    cd $curr_dir
    cd $found_dir
  end
end


set -gx PATH $PATH "/mnt/c/Users/Ajit.Singh/Downloads/notify-send/"

# this won't work for Sublime Merge. For it, create a `git-gpn` file
# inside a dir which is present in the `$PATH`. Make it `chmod u+x` and in its content
# start with `#!/usr/bin/fish` followed by content inside following function
function git_push_and_notify
  if git push --force-with-lease origin $argv
    notify-send.exe "Push Success" "Keep pushin'! ✔"
  else
    notify-send.exe -i error "Push failure" "Is it lint or test?"
  end
end

# to use it supply a commit hash or `HEAD`, 
# if nothing is specified then it'll start right after from the point where it was diverged from remote
function git_recommit
  set -l first_commit_hash $argv[1]

  if [ "$first_commit_hash" = "" ]
    # check if an upstream is present for current branch and
    # it has same name as local branch
    set -l upstream_or_err (git rev-parse --symbolic-full-name --abbrev-ref @{u})
    if test $status -eq 0
      set -l upstream_branch (echo $upstream_or_err | sed 's/.\+\///')
      set -l current_branch (git branch --show-current)
      if [ "$upstream_branch" != "$current_branch" ]
	echo "Upstream branch name ($upstream_branch) does not matches current branch name ($current_branch)"
	return 4
      end
    else
      echo "Upstream branch isn't defined for current local branch"
      return 3
    end

    set -l common_ancestor (git merge-base HEAD HEAD@{u})
    set first_commit_hash (git rev-list --topo-order --ancestry-path --reverse $common_ancestor...HEAD | head -1)

    if [ "$first_commit_hash" = "" ]
      set first_commit_hash "HEAD"
    end

    set -l commit_msg (git log --format=%B -n 1 $first_commit_hash)
    echo "No commit hash provided, using: $commit_msg ($first_commit_hash)"
    echo
  end

  # check if the inferred/supplied $first_commit_hash is a valid ancestor
  if not git merge-base --is-ancestor $first_commit_hash HEAD
    echo "Either $first_commit_hash is not an ancestor of HEAD or a commit with that hash doesn't exist"
    return 1
  end

  set -l commits_count (git log $first_commit_hash..HEAD --pretty=oneline | wc -l)
  while test $commits_count -ge 0
    if not git recommit HEAD~$commits_count
      echo "ERROR IN COMMITING — if you have staged changes, add fixes to \
solve the issue which caused this commit to fail and \
use `git commit --amend` followed by `git rebase --continue` to complete the process. \
To abort this process instead, use `git rebase --abort`."
      return 2
    end

    set commits_count (math $commits_count - 1)
  end
end

function git_recommit_and_notify
  # git_run_pre_commit_hook $argv[1]
  # and notify-send.exe "Done running commit hooks" "Go for the push! 🏂"
  # or notify-send.exe -i error "Commit hook failed" "Welp back to work"
  # ^ this syntax is valid too, for one liner, these lines will be separated by `;`
  # because I needed a non-zero status code I had to comment this out

  if git_recommit $argv[1]
    notify-send.exe "Done running commit hooks" "Go for the push! 🏂"
  else
    notify-send.exe -i error "Commit hook failed" "Welp back to work"
    return 1
  end
end
