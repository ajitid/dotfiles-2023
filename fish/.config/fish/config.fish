# cd ~
if status is-interactive
  cd $HOME
end

set -U fish_greeting

# use `eval (ssh-agent -c)` or github.com/danhper/fish-ssh-agent

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/scripts/git"

set -x SUDO_EDITOR "$HOME/.local/bin/nvim.appimage"

set -x _ZO_ECHO 1
zoxide init --cmd j fish | source

export PATH="$PATH:"(go env GOPATH)"/bin"
#  export GOPHERJS_GOROOT=(go env GOROOT)

# to pipe and copy contents to clipboard, other ways mentioned here https://askubuntu.com/a/705658/726406
abbr clip "xsel -ib"

# https://github.com/PatrickF1/fzf.fish/blob/a79dc7510d02f25360c2f30e50287abd0766a588/functions/_fzf_wrapper.fish#L16
set -x FZF_DEFAULT_OPTS '--layout=reverse --cycle --info=default --height=90% --marker="> " --color=bg+:#1e2132,gutter:-1,pointer:#84a0c6,spinner:#84a0c6,marker:#b4be82,fg+:-1,hl+:-1,fg:-1,hl:-1'

# this coud've worked but just didn't: `ghq list | fzf | sed 's|^|~/ghq/|' | xargs cd`
# ^ replace `cd` with `echo` to confirm output
# seems like https://superuser.com/questions/929377/can-xargs-evaluate-home
# https://superuser.com/questions/893890/xargs-change-working-directory-to-file-path-before-executing
# https://superuser.com/questions/206789/using-xargs-to-cd-to-a-directory
# https://www.linuxquestions.org/questions/linux-newbie-8/xargs-cd-is-not-working-796219/
#
# more options at https://unix.stackexchange.com/questions/360540/append-to-a-pipe-and-pass-on
abbr gi "cd ~/ghq/(ghq list | fzf)"
abbr gg "ghq get -p"

fzf_configure_bindings --directory=\cf --git_log --git_status --variables

alias l='ls -alhp --group-directories-first'

function mkcd --description 'Create and enter directory'
  if mkdir $argv
    if string match -qv -- '-*' $argv[-1]
      cd $argv[-1]
    end
  end
end

export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$HOME/miniconda3/bin:$PATH"

## this is to initialize `base` environment of miniconda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval $HOME/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# need to run one time to update completions, can be
# uncommented here to ensure it remains updated
# pdm completion fish > ~/.config/fish/completions/pdm.fish

# output of `pdm --pep582 fish >> ~/.config/fish/config.fish`
if test -n "$PYTHONPATH"
    set -x PYTHONPATH '/home/zlksnk/.local/share/pdm/venv/lib/python3.9/site-packages/pdm/pep582' $PYTHONPATH
else
    set -x PYTHONPATH '/home/zlksnk/.local/share/pdm/venv/lib/python3.9/site-packages/pdm/pep582'
end

# not needed anymore, this also used to hang Fish when a command is ran
# export DISPLAY=(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
# export LIBGL_ALWAYS_INDIRECT=0

# abbr can be used too, see https://github.com/jonhoo/configs/blob/master/shell/.config/fish/config.fish#L1
# seems like it must be preferred over alias https://www.sean.sh/log/when-an-alias-should-actually-be-an-abbr/
abbr v 'nvim.appimage'
abbr vv 'nvim.appimage -S'
abbr v. 'nvim.appimage --cmd "let g:rooter_manual_only=1"'

# abbr process running on a port "sudo lsof -i:3000"

# see for info https://github.com/mhinz/neovim-remote/
# and https://thoughtbot.com/upcase/videos/neovim-remote-as-preferred-editor
alias vr "NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim.appimage"

export PATH="$PATH:$HOME/execs"
alias g "/usr/bin/smerge"

# https://github.com/pstadler/keybase-gpg-github#troubleshooting-gpg-failed-to-sign-the-data
# https://github.com/keybase/keybase-issues/issues/2798#issue-205008630
export GPG_TTY=(tty)
# to sign commits, use 
# git config user.signingkey <the key that appears after 'sec rsa-or-something/'
# `gpg -K --keyid-format LONG`>
# so git config user.signingkey 84CDEEF91EF296D9
# and 
# git config commit.gpgsign true
# 
# to not to enter passphrase in a system
# gpg --passwd <yourkeyid or email>
# and use empty string as new passphrase

# https://askubuntu.com/questions/499807/how-to-unzip-tgz-file-using-the-terminal
abbr tarunzip 'tar --extract --one-top-level --file'

set -x N_PREFIX "$HOME/n"; contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# begin
#   set --local AUTOJUMP_PATH $HOME/.autojump/share/autojump/autojump.fish
#   if test -e $AUTOJUMP_PATH
#     source $AUTOJUMP_PATH
#   end
# end

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

# this won't work for Sublime Merge. For it, create a `git-gpn` file
# inside a dir which is present in the `$PATH`. Make it `chmod u+x` and in its content
# start with `#!/usr/bin/fish` followed by content inside following function
function git_push_and_notify
  if git push --force-with-lease origin $argv
    notify-send.exe "Push Success" "Keep pushin'! ✔" &
  else
    notify-send.exe -i error "Push failure" "Is it lint or test?" &
  end
end

# to use it supply a commit hash or `HEAD`, 
# if nothing is specified then it'll start right after from the point where it was diverged from remote
function git_recommit
  # check if it is not a git repo
  if not git rev-parse --is-inside-work-tree >/dev/null
    return 5
  end

  if test -d (git rev-parse --git-path rebase-merge); or test -d (git rev-parse --git-path rebase-apply)
    echo "Can't continue as you are in the middle of a rebase."
    return 6
  end

  set -l force_commit 0

  # TODO there would be a better way to parse arguments (there is `argparse`)
  switch $argv[1]
    case '-f' or '--force'
      set force_commit 1
      # Erase not only removes content of argv[1] but also shifts content of 2->1, 3->2, etc.
      # So if command is `blah -f something`, on erasing argv[1] (which is `-f`), `something` will take its place.
      # Bash equivalent is `shift`.
      set --erase argv[1]
    # no `break` is required as fallthrough is managed by `or` like we used above
  end

  set -l first_commit_hash $argv[1]

  if [ "$first_commit_hash" = "" ]
    # check if an upstream is present for current branch and
    # it has same name as local branch
    set -l upstream_or_err (git rev-parse --symbolic-full-name --abbrev-ref @{u})
    if test $status -eq 0
      set -l upstream_branch (echo $upstream_or_err | cut -d '/' -f 2-)
      set -l current_branch (git branch --show-current)
      if [ "$upstream_branch" != "$current_branch" ]; and test $force_commit -eq 0
        echo "Upstream branch name ($upstream_branch) does not matches current branch name ($current_branch)."
        echo "To use this upstream branch anyway, add `--force` (or succinctly `-f`) flag."
        return 4
      end
    else
      echo "Upstream branch isn't defined for current local branch"
      return 3
    end

    set -l common_ancestor (git merge-base HEAD HEAD@{u})
    set first_commit_hash (git rev-list --topo-order --ancestry-path --reverse --abbrev-commit $common_ancestor...HEAD | head -1)

    # if this gives empty then there is no common ancestor which means
    # commit hash of HEAD (local branch) == commit hash of HEAD@{u} (upstream branch)
    if [ "$first_commit_hash" = "" ]
      # apart from `fmt` there is also `fold
      # see https://unix.stackexchange.com/questions/25173/how-can-i-wrap-text-at-a-certain-column-size
      echo "Seems like both local and remote branches have their HEAD pointing to the same commit. \
This usually means your local branch is up to date with remote." | fmt
      echo
      echo "If you want to recommit this anyway, pass `HEAD` as argument."
      return 7
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
  for head_ancestor in (seq 0 $commits_count)[-1..1]
    if not git recommit HEAD~$head_ancestor
      echo

      if test -d (git rev-parse --git-path rebase-merge); or test -d (git rev-parse --git-path rebase-apply)
        echo "Error in recommiting — if you are in the middle of a rebase and have staged changes, \
add fixes to resolve the issue which caused this commit to fail and \
use `git commit --amend` followed by `git rebase --continue` to complete the process. \
To abort this process instead, use `git rebase --abort`." | fmt
        return 2
      else
        echo "Error in recommiting — please try to debug the cause from info given above."
        return 8
      end
    end

    # set commits_count (math $commits_count - 1) # was needed for while loop
    # on the same note, fish also supports `break` and `continue`
  end
end

function git_recommit_and_notify
  # git_run_pre_commit_hook $argv[1]
  # and notify-send.exe "Done running commit hooks" "Go for the push! 🏂"
  # or notify-send.exe -i error "Commit hook failed" "Welp back to work"
  # ^ this syntax is valid too, for one liner, these lines will be separated by `;`
  # because I needed a non-zero status code I had to comment this out

  if git_recommit $argv[1]
    notify-send.exe "Done running commit hooks" "Go for the push! 🏂" &
  else
    set -l err_code $status
    notify-send.exe -i error "Commit hook failed" "Welp back to work" &
    return $err_code
  end
end

abbr -a -- - 'cd -'

# tree -d -L 2 -I 'node_modules|e2e_Tests|*mocks*'

# I don't watch Futurama :(
function deathbysnusnu
  # from https://stackoverflow.com/questions/13910087/shell-script-to-capture-process-id-and-kill-it-if-exist#comment83939035_15896729
  # created this because pkill or killall doesn't work for me and I need to use -9 flag
  # which results in not allowing to be cleanup to be made, as I really want to force remove the app
  # there is `ps aux` too, I don't know the difference b/w these
  # I used `sed` and xargs in my original script but who cares

  set -l grep_arg (string join '|' (string split ' ' $argv))

  # grep -E so that processes can be found using `'nvim|smerge'`
  set -l ids (ps -ef | grep -E $grep_arg | grep -v grep | awk '{print $2}')
  if [ "$ids" = "" ]
    echo "deathbysnusnu: no active program to end"
    return 1
  end

  kill -9 $ids
end

# folder/file size
# du -h --max-depth=1 | sort -hr
# where r stands to show high to low in folder size
abbr huge "du -h --max-depth=1 | sort -hr"
# alternative https://github.com/bootandy/dust

# needs imagemagick, also see nnn
alias icat="kitty +kitten icat"

source ~/.config/fish/kanagawa.fish

# in case kitty's F1 shortcut isn't available, this is the way to pipe stuff to nvim:

# capture the output of a command so it can be retrieved with ret
function cap
  tee /tmp/capture.out
end

# return the output of the most recent command that was captured by cap
function ret
  cat /tmp/capture.out
end

set -x EDITOR "nvim.appimage"

# remove duplicate lines (except the blank ones) from welp and put the result into file welp2
# awk 'length == 0 ? 1 : !a[$0]++' welp > welp2

# pnpm
set -gx PNPM_HOME "/home/ajitid/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

abbr pn "pnpm"

## ajit: this is for pnpm autocompletion https://pnpm.io/completion
# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true
