#!/bin/sh
# update
sudo apt update
sudo apt upgrade

# sort with :.,/ENDPROGRAMS/-1!sort
# install programs
xargs sudo apt-get --assume-yes install << ENDPROGRAMS
anki
audacity
clementine
curl
dmenu
ffmpeg
firefox
ghc
gimp
git
hoogle
imagemagick
luajit
maim
neovim
pandoc
pandoc-citeproc
qutebrowser
ranger
rxvt-unicode
suckless-tools
trash-cli
vlc
wget
wget
xdotool
xinit
zathura
zathura-pdf-poppler
zsh
ENDPROGRAMS

# sudo useradd --groups sudo --create-home --shell zsh --user-group  zander

if [ ! -e .dotfiles.git ]
then
	git clone --bare \
		https://github.com/zandroidius/dotfiles.git \
		.dotfiles.git
	
	alias gitdotfiles="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"
	
	mkdir -p before-dotfiles-backup && \
	gitdotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
	xargs -I{} mv {} before-dotfiles-backup/{}
	
	gitdotfiles checkout
	gitdotfiles config --local status.showUntrackedFiles no
fi

# Neovim
plug=$HOME/.local/share/nvim/site/autoload/plug.vim
if [ ! -e "$plug" ]
then
	curl -fLo "$plug" --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	
	mkdir -p ~/.vim/plugged

	nvim --headless +PlugInstall
fi

# ZSH
if [ ! -e ~/.zimrc ]
then
	wget -nv -O - https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi

# st
if [ ! -e ~/progs/smith-st ]
then
	cd ~/progs
	git clone https://github.com/LukeSmithxyz/st smith-st
	cd smith-st
	sudo make clean install
fi

dwmdir=$HOME/progs/new-dwm
if [ ! -e $dwmdir/dwm-6.2 ]
then
	cd $dwmdir
	sh download.sh
	cd dwm-6.2
	sudo make clean install
fi
