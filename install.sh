#!/usr/bin/env bash

mkdir_recursive() {
    basedir=$1
    find "$basedir" -type d | while read -r dir; do
        relative_dir="${dir#$basedir/}"
        if [[ ! $relative_dir =~ ^\.$|\.git ]]; then
            mkdir -vp "$HOME/$relative_dir"
        fi
    done
}

hostname=$(cat /etc/hostname)
scriptdir=$(dirname "$0")

if [[ $hostname =~ thinkpad|desktop ]]; then
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
    [[ ! -d $HOME/.fzf ]] && git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# zsh
if [[ $SHELL != /bin/zsh ]]; then
    echo "Switching to zsh"
    chsh -s /bin/zsh
fi

# Kickstart neovim https://github.com/nvim-lua/kickstart.nvim
if [[ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim ]]; then
    git clone https://github.com/myspace7164/kickstart.nvim.git $HOME/.config/nvim
else
	pushd "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
	git pull
	popd
fi
nvim --headless "+Lazy! sync" +qa

# Build dotfile tree and stow files
mkdir_recursive $scriptdir/system
stow --verbose --restow --target $HOME --dir $scriptdir system

if [[ $hostname =~ thinkpad|desktop ]]; then
    # reload sway
    swaymsg reload

    # Create user-dirs.dirs directories
    mkdir -vp $HOME/tmp
    mkdir -vp $HOME/.local/share/desktop
    mkdir -vp $HOME/.local/share/templates
    mkdir -vp $HOME/.local/share/public
    mkdir -vp $HOME/.local/share/documents
    mkdir -vp $HOME/.local/share/music
    mkdir -vp $HOME/.local/share/pictures
    mkdir -vp $HOME/.local/share/videos

    systemctl --user daemon-reload

    systemctl --user enable unison-drive.service
    systemctl --user start unison-drive.service

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
fi

# If default ssh key does not exist, generate one and print it
[[ ! -f $HOME/.ssh/id_rsa ]] && ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa -N ""
cat $HOME/.ssh/id_rsa.pub
