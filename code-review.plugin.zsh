function code-review () {
  local is_git=$(git rev-parse --is-inside-work-tree 2> /dev/null)
  if [ -z $is_git ]; then
    echo "not a git repository"
    return
  fi

  local base_branch=${1:-${GIT_BASE_BRANCH:-master}}
  local target_branch=${2:-HEAD}

  local merge_base=$(git merge-base $target_branch $base_branch)

  local shortstatout=$(git diff --shortstat --color $merge_base $target_branch)
  local statout=$(git diff --stat --color $merge_base $target_branch)
  local filesout=$(git diff --name-only $merge_base $target_branch)

  local LESS
  local selectfile

  setopt localtraps
  trap '' 2

  while true; do
    # alternate screen
    echo -ne "\e[?1049h"
    # clear screen; move to top left
    echo -ne "\e[2J\e[H"
    echo " comparing $base_branch..$target_branch"
    echo $shortstatout
    echo -n " Usage: l - list changed files, f - launch difftool for file, q - quit"
    read -sk opt
    case $opt in
      (l)
        echo $statout | less -c -g -i -M -R -S -w -X -z-4
        ;;
      (f)
        selectfile=$(echo "$filesout" | fzf --reverse --preview '[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --color=always -r :$FZF_PREVIEW_LINES {} || head -$FZF_PREVIEW_LINES {}) 2> /dev/null')
        # alternate screen
        echo -ne "\e[?1049h"
        echo selectfile: "begin${selectfile}end"
        if [ -z $selectfile ]; then
        else
          git difftool --no-prompt $merge_base $target_branch -- $selectfile
        fi
        ;;
      (q)
        break
        ;;
    esac
  done

  # revert alternate screen
  echo -ne "\e[?1049l"
}
