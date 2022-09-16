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
# mkdir -p ~/.config-backup && gitdot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.config-backup/{}
# gitdot checktout

gitdot config --local status.showUntrackedFiles no

gitdot submodule update --init
```

init some config first:

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

use systemd to boot Plasma:

`kwriteconfig5 --file startkderc --group General --key systemdBoot true`

links:

[Plasma and the systemd boot](https://invent.kde.org/plasma/plasma-workspace/-/wikis/Plasma-and-the-systemd-boot)

[初等記憶體 - Linux 用户环境变量设置](https://axionl.me/p/linux-%E7%94%A8%E6%88%B7%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F%E8%AE%BE%E7%BD%AE/)
