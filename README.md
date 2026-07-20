# termux-dotfiles

My dotfiles and post-install script for Termux.

## Installation

```sh
cd /path/to/where/you/keep/your/git/repositories
git clone --recursive git@github.com:NecRaul/termux-dotfiles.git
cd termux-dotfiles
./install.sh
source ~/.bashrc
```

## Storage permission

The script runs `termux-setup-storage` for you, which will prompt for the storage permission on first run. Accept it so `~/storage` gets linked correctly.
