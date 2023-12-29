# jump to git repo root dir
function jump-to-git-root {
  local _root_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ $? -gt 0 ]]; then
    >&2 echo 'Not a Git repo!'
    exit 1
  fi
  local _pwd=$(pwd)
  if [[ $_pwd = $_root_dir ]]; then
    # Handle submodules:
    # If parent dir is also managed under Git then we are in a submodule.
    # If so, cd to nearest Git parent project.
    _root_dir="$(git -C $(dirname $_pwd) rev-parse --show-toplevel 2>/dev/null)"
    if [[ $? -gt 0 ]]; then
      echo "Already at Git repo root."
      return 0
    fi
  fi
  # Make `cd -` work.
  OLDPWD=$_pwd
  echo "Git repo root: $_root_dir"
  cd $_root_dir
}
# Make short alias
alias gr=jump-to-git-root

# gitmydot
# https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git
alias gitdot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
[ -f /usr/share/bash-completion/completions/git ] && source /usr/share/bash-completion/completions/git
__git_complete gitdot __git_main

# gitui
alias gituidot='/usr/bin/gitui --directory=$HOME/.dotfiles/ --workdir=$HOME'
