# dotfiles

my arch dotfiles

|Shell (Shell framework)|WM / DE|Editor|Terminal|Multiplexer|Monitor|File Manager|
|----|----|----|----|----|----|----|
|bash|KDE|vim / vscode|kconsole / alacritty|tmux|htop|ranger|

## Usage

### Install this dotfiles onto a new system (or migrate to this setup)

```bash
alias gitdot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

git clone --bare https://github.com/test482/dotfiles.git ~/.dotfiles

gitdot checktout

# backup configuration files that might already exist if needed
mkdir -p ~/.config-backup && gitdot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.config-backup/{}

gitdot checktout

gitdot config --local status.showUntrackedFiles no
```

init some config frist

```bash
sudo cp ~/.config/pacman/pacman.conf /etc/
sudo cp ~/.config/pacman/hooks/* /etc/pacman.d/hooks/
sudo pacman -Sy archlinuxcn-keyring
```
