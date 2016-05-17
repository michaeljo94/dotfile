#!/bin/bash

StartPath=$PWD
VundlePath=$HOME/.vim/bundle/Vundle.vim
TpmPath=$HOME/.tmux/plugins/tpm
DotfilePath=$HOME/dotfile

function dep {
#Arch Dependencies
if [ -e /bin/pacman ]; then
    sudo pacman -Syu tmux vim zsh openssl yajl powerline powerline-fonts pydf wget curl --noconfirm 
fi
}
function jogurt {

    mkdir /tmp/$USER-yaourt
    cd /tmp/$USER-yaourt
    
    git clone https://aur.archlinux.org/package-query.git
    cd package-query
    makepkg -si --noconfirm
    cd ..
    git clone https://aur.archlinux.org/yaourt.git
    cd yaourt
    makepkg -si --noconfirm
    cd ..
    
    cd $StartPath
    rm -rf /tmp/$USER-yaourt
}


function repo {
# Dotfile Repo
if [ ! -d $HOME/dotfile ]; then
    printf "Downloading dotfile\n"
    git clone https://github.com/michaeljo94/dotfile.git $DotfilePath 
fi

#Vundel for vim
if [ ! -e $HOME/.vim/bundle/Vundle.vim ]; then
    printf "Downloading Vundle for Vim\n"
    git clone https://github.com/VundleVim/Vundle.vim.git $VundlePath
fi

#tmux plugin manager 
if [ ! -d $HOME/.tmux/plugins/tpm ]; then
    printf "Downloading Tmux plugin Manager\n"
    git clone https://github.com/tmux-plugins/tpm $TpmPath
fi
}
#link powerline to ~/.local/bin
function safelinkd {
    if [ ! -d $HOME/$2 ]; then
        ln -s $1 $HOME/$2
        echo $(basename $1) linked succesfully
    else
        echo $(basename $1) already exists in $2 
    fi
}

#linking rc-files
function safelink {
   if [ ! -e $HOME/$1 ]; then
       ln -s $HOME/dotfile/$1 $HOME/$1
       echo $1 linked succesfully\n
   else
       echo $1 already exists\m
   fi
}
function install {
printf "Trying to link RunControl\n\n"

safelink .gitconfig
safelink .vimrc
safelink .tmux.conf
safelink .zshrc
safelinkd /usr/lib/python3.5/site-packages/powerline .local/bin/powerline

#change shell to zsh
if [ $SHELL != "/bin/zsh" ]; then
    chsh -s /bin/zsh
  else
    printf "you are alread using ZSh\n\n"
fi
}

function update () {
    cd $1
    printf "Checking %s ...\t" "$(basename $1)"
    git pull
    cd $StartPath
}

if [ "$1" == "install" ]; then

    dep
    repo
    install

    elif [ "$1" == "yaourt" ]; then

        jogurt

    elif [ "$1" == "update" ]; then

        update $DotfilePath
        update $VundlePath
        update $TpmPath

    else
            echo "This is a feature not a bug"
        fi
