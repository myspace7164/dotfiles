#!/usr/bin/env bash

distro=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
hostname=$(cat /etc/hostname)
scriptdir=$(readlink -f $(dirname "$0"))

mkdir -vp $HOME/cloud
mkdir -vp $HOME/repos
mkdir -vp $HOME/tmp

mkdir -vp $HOME/.user-dirs.dirs/Desktop
mkdir -vp $HOME/.user-dirs.dirs/Templates
mkdir -vp $HOME/.user-dirs.dirs/Public
mkdir -vp $HOME/.user-dirs.dirs/Documents
mkdir -vp $HOME/.user-dirs.dirs/Music
mkdir -vp $HOME/.user-dirs.dirs/Pictures
mkdir -vp $HOME/.user-dirs.dirs/Videos

if [[ $distro == nixos ]]; then
    nix flake update --flake $scriptdir
    sudo nixos-rebuild switch --flake $scriptdir
    exit
elif [[ $hostname =~ arch ]]; then
    # Enable colors in pacman
    sudo sed -i 's/^#Color$/Color/' /etc/pacman.conf

    # Enable multilib
    sudo perl -0777 -i -pe 's/#\[multilib\]\n#Include = (.*)/[multilib]\nInclude = $1/' /etc/pacman.conf

    # Initial update and cleanup
    sudo pacman -Suy --noconfirm --needed
    sudo pacman -Qdtq | sudo pacman -Rns -

    # First things first, let's install yay
    if [[ ! -e /usr/bin/yay ]]; then
	    sudo pacman -S --noconfirm --needed git base-devel
	    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay
        pushd /tmp/yay
	    makepkg -si
        popd
    fi

    yay -Syu --noconfirm --needed
    yay -S --noconfirm --needed - < $scriptdir/packages/arch/packages.txt
    yay -Yc --noconfirm

    # rust
    rustup default stable

    #libvirt
    sudo gpasswd -a user libvirt
    sudo virsh net-start default
    sudo virsh net-autostart default

    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service

    sudo systemctl enable avahi-daemon.service
    sudo systemctl start avahi-daemon.service

    sudo systemctl enable cups.service
    sudo systemctl start cups.service

    sudo systemctl start tlp.service
    sudo systemctl enable tlp.service

    sudo systemctl start libvirtd.service
    sudo systemctl enable libvirtd.service

elif [[ $hostname == "fedora" ]]; then
    # Flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    # Iosevka
    copr_list=$(dnf copr list)
    copr_repo="peterwu/iosevka"
    if ! echo "$copr_list" | grep -q $copr_repo || echo "$copr_list" | grep -q "$copr_repo (disabled)"; then
        echo "$copr_repo not yet enabled, enabling now..."
        sudo dnf -y copr enable $copr_repo
    else
        echo "$copr_repo already enabled"
    fi

    sudo dnf update -y
    cat $basedir/../../.config/fedora/pkglist.txt | xargs sudo dnf install -y
    sudo dnf autoremove -y

    flatpak update -y
    cat $basedir/../../.config/$flatpak_dir/flatpak-pkglist.txt | xargs flatpak install -y

elif [[ $hostname == "CHLFSTL0014" ]]; then
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt update
    sudo apt upgrade --assume-yes
    sudo apt autoremove --assume-yes

    sudo xargs -a $scriptdir/packages/ubuntu/wsl.txt apt install -y

    # fzf is quite old on ubuntu, so install it from git
    if [[ ! -d $HOME/.fzf ]]; then
	    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    else
	    pushd $HOME/.fzf
	    git pull
	    popd
    fi
    $HOME/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

    mkdir -vp $HOME/.emacs.d
    ln -sf $scriptdir/config/emacs/early-init.el $HOME/.emacs.d
    ln -sf $scriptdir/config/emacs/init.el $HOME/.emacs.d

    mkdir $HOME/.config/git
    ln -sf $scriptdir/config/git/config $HOME/.config/git

    mkdir $HOME/.config/nvim
    ln -sf $scriptdir/config/nvim/init.lua $HOME/.config/nvim

    mkdir $HOME/.config/tmux
    ln -sf $scriptdir/config/tmux/tmux.conf $HOME/.config/tmux

    ln -sf $scriptdir/config/zsh/.zprofile $HOME
    ln -sf $scriptdir/config/zsh/.zshenv $HOME
    ln -sf $scriptdir/config/zsh/.zshrc $HOME
fi

# zsh
if [[ $distro != nixos && $SHELL != /bin/zsh ]]; then
    echo "Switching to zsh"
    chsh -s /bin/zsh
fi

if [[ $hostname =~ thinkpad|desktop|pocket ]]; then
    # reload sway
    swaymsg reload

    systemctl --user daemon-reload

    systemctl --user enable unison-drive.service
    systemctl --user start unison-drive.service
fi

# If default ssh key does not exist, generate one and print it
[[ ! -f $HOME/.ssh/id_rsa ]] && ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa -N ""
cat $HOME/.ssh/id_rsa.pub

# Arkenfox
if command -v firefox > /dev/null 2>&1; then
	bash $basedir/../scripts/arkenfox.sh
fi
