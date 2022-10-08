# dotfiles

my arch dotfiles

|Shell (Shell framework)|WM / DE|Editor|Terminal|Multiplexer|Monitor|File Manager|
|----|----|----|----|----|----|----|
|bash|KDE|vim / vscode|konsole / alacritty|tmux|htop|ranger|

## Usage

### Install this dotfiles onto a new system (or migrate to this setup)

```bash
alias gitdot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

git clone --bare https://github.com/test482/dotfiles.git ~/.dotfiles

gitdot checktout

# backup configuration files that might already exist if needed
# mkdir -p ~/.config-backup && gitdot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.config-backup/{}
# gitdot checktout

gitdot config --local status.showUntrackedFiles no

gitdot submodule update --init

# ignore some files change
gitdot update-index --skip-worktree $HOME/.ssh/authorized_keys
```

### init some config first

```bash
# pacman
sudo cp $HOME/.config/pacman/pacman.conf /etc/pacman.conf
sudo cp $HOME/.config/pacman/pacman.d/mirrorlist /etc/pacman.d/mirrorlist
sudo cp $HOME/.config/pacman/hooks/* /etc/pacman.d/hooks/
sudo pacman -Sy archlinux-keyring
sudo pacman -Sy archlinuxcn-keyring
# install pkgs
sudo pacman -Sy $(< $HOME/.config/pacman/pkg-list/cli.txt) # or other pkgs
```

### [use systemd to boot Plasma](https://invent.kde.org/plasma/plasma-workspace/-/wikis/Plasma-and-the-systemd-boot)

`kwriteconfig5 --file startkderc --group General --key systemdBoot true`

> as [KDE - ArchWiki](https://wiki.archlinux.org/title/KDE#systemd_startup) say, `This is the default startup method since Plasma 5.25`, so don't need do this on KDE Plasma 5.25+ .
