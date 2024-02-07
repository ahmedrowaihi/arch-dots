#!/bin/bash

# The following will attempt to install all needed packages I usually use
# This is a quick and dirty script; there are no error checking
# This script is meant to run on a clean fresh Arch install
#
# NOTE:
# This script assumes that Linux kernel, grub
# and base packages are installed and configured
#
# Below is a list of the packages that would be installed
#
# yay: AUR package helper
# picom: compositor for Xorg
# polybar: status bar for Xorg
# sxhkd: key bindings mapper for bspwm
# bspwm: window manager
# rofi: application launcher (used for window switching)
# dmenu: application launcher
# btop: CLI-based system monitor
# nemo: a graphical file manager
# alacritty: a terminal
# firefox: yeah, I use Firefox
# neovim: a text editor
# vim: another text editor
# vscodium-bin: another text editor
# nitrogen: wallpaper switcher
# ttf-jetbrains-mono: JetBrains Mono font
# ttf-jetbrains-mono-nerd: Some nerd fonts for icons and overall look
# noto-fonts-emoji: fonts needed by the weather script in the top bar
# brightnessctl: used to control monitor brightness level
# gvfs: adds missing functionality to Thunar such as auto-mounting USB drives
# bluez: the Bluetooth service
# bluez-utils: command-line utilities to interact with Bluetooth devices
# lxappearance: used to set GTK theme
# go: Go programming language
# rust: Rust programming language
# cmake: Cross-platform build system
# clang: C and C++ compiler
# grpc: Google's remote procedure call (RPC) framework
# protobuf: Protocol Buffers
# pavucontrol: PulseAudio volume control
# openssh: OpenSSH client and server
# dmidecode: DMI table decoder
# zsh: Zsh shell
# amd-ucode: Microcode updates for AMD processors
# arandr: A simple visual front end for XRandR
# amdgpu_top: A command-line tool for monitoring AMD GPU utilization
# pulseaudio: Sound server
# alsa-utils: Advanced Linux Sound Architecture (ALSA) utilities
# xf86-video-qxl: Xorg QXL video driver for virtualized environments
# xorg: Xorg display server
# xorg-xinit: Xorg initialization
# pacman-contrib: Useful additional tools and scripts for pacman package manager
# git: Version control system
# mesa: Graphics library for 3D applications
# base-devel: Development tools (for compiling AUR packages)
# networkmanager: Network connection manager
# wpa_supplicant: Wireless network authentication
# wireless_tools: Tools for wireless network configuration
# netctl: Network control utility
# dialog: A tool to create dialog boxes from shell scripts
# lvm2: Logical Volume Management tools
# rsync: Remote file synchronization tool
# tmux: Terminal multiplexer
# fzf: cli fuzzy finder
# ufw: firewall rules manger
# mariadb/mysql: MariaDB is the default implementation of MySQL in Arch Linux
# postgresql: postgresql db
# fastfetch: neofetch for sys-info
# bat: code hilight util

INSTALLERDIR=$(dirname "$0")

pacman_packages=(
	fastfetch picom polybar sxhkd bspwm 
	rofi dmenu btop nemo alacritty 
    	firefox neovim vim nitrogen 
	brightnessctl gvfs bluez bluez-utils 
	lxappearance go rust cmake 
	clang grpc protobuf pavucontrol 
	openssh dmidecode zsh amd-ucode 
	arandr pulseaudio alsa-utils 
	xf86-video-qxl xorg xorg-xinit 
	pacman-contrib git mesa
	base-devel networkmanager wpa_supplicant
	wireless_tools netctl dialog lvm2
	rsync tmux fzf bat
)

# Install packages with pacman
echo -e "Installing packages with pacman...\n"
if ! sudo pacman -S "${pacman_packages[@]}"; then
    echo -e "Error: pacman installation failed. Exiting script.\n"
    exit 1
fi

# start the SSH server
read -n1 -rep 'would you like to start SSH server? (y,n)' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
	echo -e "Starting SSH server...\n"
	if sudo systemctl enable --now sshd; then
    		echo -e "SSH server started successfully.\n"
    		sleep 3
	else
    		echo -e "Error: Failed to start the SSH server. Exiting script.\n"
    		exit 1
	fi
fi

# start NetworkManager
echo -e "Starting NetworkManager....\n"
if sudo systemctl enable --now NetworkManager; then
    echo -e "NetworkManager started successfully.\n"
    sleep 3
else
    echo -e "Error: Failed to start NetworkManager. Exiting script.\n"
    exit 1
fi

# Start MySQL (MariaDB)
read -n1 -rep 'setup a MySQL (MariaDB) (y,n)' HYP
if [[ $HYP == 'Y' || $HYP == 'y' ]]; then	
	echo -e "Starting MariaDB...\n"	
	if sudo pacman -S "mariadb"; then
		if mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql && sudo systemctl enable mariadb.service; then
    			echo -e "MariaDB started successfully.\n"
    			sleep 3
		else
    			echo -e "Error: Failed to start MariaDB. Exiting script.\n"
    			exit 1
		fi
	else
		echo -e "Error: Failed to install MariaDB. Exiting...\n"
		exit 1
	fi
fi

# Start PostgreSQL 
read -n1 -rep 'setup a PostgreSQL (y,n)' HYP
if [[ $HYP == 'Y' || $HYP == 'y' ]]; then
	echo -e "Starting PostgreSQL...\n"
	if sudo pacman -S "postgresql"; then
		# switch to the postgres user and initialize the data directory
		if sudo -iu postgres && initdb -D /var/lib/postgres/data && exit; then
    			echo -e "PostgreSQL initialized successfully.\n"
    			sleep 3
			# enable the PostgreSQL service
			if sudo systemctl enable postgresql; then
    				echo -e "PostgreSQL service enabled successfully.\n"
			else
    				echo -e "Error: Failed to enable PostgreSQL service. Exiting script.\n"
    			exit 1

			fi
		else
    			echo -e "Error: Failed to initialize PostgreSQL. Exiting script.\n"
    			exit 1
		fi
	fi
fi

echo -e "Looking for yay...\n"
sleep 2
# check for yay and install if not found
if ! command -v yay &>/dev/null; then
    echo -e "yay not found. Installing yay...\n"
    git clone https://aur.archlinux.org/yay.git
    (cd yay && makepkg -si)
    # check for yay installation success
    if ! command -v yay &>/dev/null; then
        echo -e "Error: yay installation failed. Exiting script.\n"
        exit 1
    fi
else
    echo -e "yay is already installed. Proceeding...\n"
fi


# install AUR packages with yay
echo -e "Installing AUR packages with yay...\n"
if ! yay -S \
    vscodium-bin ttf-jetbrains-mono ttf-jetbrains-mono-nerd \
    noto-fonts-emoji amdgpu_top vscodium-bin ttf-arabeyes-fonts gputest; then
    echo -e "Error: AUR package installation failed. Exiting script.\n"
    exit 1
fi

# copy config files
echo -e "Copying config files...\n"
config_dirs=(
	"$INSTALLERDIR/.config/rofi"
	"$INSTALLERDIR/.config/alacritty" 
	"$INSTALLERDIR/.config/polybar" 
	"$INSTALLERDIR/.config/bspwm" 
	"$INSTALLERDIR/.config/sxhkd" 
	"$INSTALLERDIR/.config/picom" 
	"$INSTALLERDIR/.config/btop"
)
for dir in "${config_dirs[@]}"; do
    if ! cp -R "$dir" $HOME/.config/; then
        echo -e "Error: Failed to copy $dir to ~/.config/. Exiting script.\n"
        exit 1
    fi
done

# Gruvbox Material GTK theme and icons
echo "Installing Gruvbox Material GTK theme and icons..."
# clone the Gruvbox Material GTK theme repository
if ! git clone https://github.com/TheGreatMcPain/gruvbox-material-gtk.git $HOME/gruvbox-material-gtk; then
    echo "Error: Failed to clone the repository. Exiting."
    exit 1
fi

# create ~/.icons and ~/.themes directories if they don't exist
echo "Creating ~/.icons and ~/.themes directories..."
if ! mkdir -p $HOME/.icons $HOME/.themes; then
    echo "Error: Failed to create directories. Exiting."
    exit 1
fi

# copy theme files to ~/.themes
if ! cp -r $HOME/gruvbox-material-gtk/themes/* $HOME/.themes; then
    echo "Error: Failed to copy theme files. Exiting."
    exit 1
fi

# copy icon files to ~/.icons
if ! cp -r $HOME/gruvbox-material-gtk/icons/* $HOME/.icons; then
    echo "Error: Failed to copy icon files. Exiting."
    exit 1
fi
echo "Gruvbox Material GTK theme and icons installed successfully!"

# Install the shell (oh-my-zsh)
echo -e "Installing oh-my-zsh...\n"
if ! sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
    echo -e "Error: Oh-My-Zsh installation failed. Exiting script.\n"
    exit 1
fi

# copy the specified dot files
dot_files=("$INSTALLERDIR/.zshrc" "$INSTALLERDIR/.xinitrc" "$INSTALLERDIR/.tmux.conf")
echo -e "Copying other dot files...\n"
for file in "${dot_files[@]}"; do
    if ! cp "$file" $HOME; then
        echo -e "Error: Failed to copy $file. Exiting."
        exit 1
    fi
	if ! chmod +x $HOME/.xinitrc; then
        echo -e "Error: failed to make $HOME/.xinitrc executable.\n"
	fi
done


# Script is done
echo -e "Script is completed.\n"
echo -e "You can start bspwm by typing startx\n"
read -n1 -rep 'Start now? (y,n)' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec startx
else
    exit
fi
