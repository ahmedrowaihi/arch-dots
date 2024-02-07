export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.config/emacs/bin:$PATH"
export QT_QPA_PLATFORMTHEME=qt5ct
# jdk
export INSTALL4J_JAVA_HOME="/usr/lib/jvm/java-17-openjdk:$PATH"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
# language | fcitx5
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
# 
export PATH="$HOME/.emacs.d/doom/bin:$PATH"
# export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"
export PATH=/usr/bin:$PATH
export EDITOR=nvim
export VISUAL="$EDITOR"
export QT_QPA_PLATFORMTHEME=qt5ct
export MY_INSTALL_DIR=$HOME/.local
# nvs | node manager
export NVS_HOME=$HOME/.nvs
# react native | android studio
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
# export PATH="$MY_INSTALL_DIR/bin:$PATH"
if ! fastfetch; then
	echo "where is your fetch?"
fi

# some random shit
_fzf() {
	fzf --multi \
		--height=100% \
		--margin=1%,0%,0%,1% \
		--layout=reverse-list \
		--border=none \
		--info=inline \
		--prompt='>>' \
		--pointer='→' \
		--marker='::' \
		--color='dark,fg+:green,prompt:blue,pointer:red,info:magenta,hl:blue,hl+:blue' \
		--preview 'bat --style=header --theme=base16 --color=always --line-range :500 {}'
}

lazy_find() {
	while getopts "t:n:d:" opt; do
		case $opt in
		t)
			target_type="$OPTARG"
			;;
		n)
			file_name="$OPTARG"
			;;
		d)
			directory="$OPTARG"
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
		esac
	done

	if [ -z "$target_type" ] || [ -z "$file_name" ] || [ -z "$directory" ]; then
		echo "Usage: $0 -t [f|d] -n [name] -d [directory]"
		return
	fi

	if [ "$target_type" != "f" ] && [ "$target_type" != "d" ]; then
		echo "Invalid target type: $target_type. Use 'f' for files or 'd' for directories."
		return
	fi

	if [ "$target_type" = "f" ]; then
		selected_files=$(find "$directory" -type f -name "$file_name")
	else
		selected_files=$(find "$directory" -type d -name "$file_name")
	fi

	if [ -n "$selected_files" ]; then
		echo "Files/Dirs found:"
		echo "$selected_files"
	else
		echo "No $target_type with the name '$file_name' found in the directory '$directory'."
		return
	fi
}

_none() {
	file=$(fzf)
	[ -n "$file" ] && nvim "$file"
}

_grep_files() {
	if [ -n "$1" ] && [ -n "$2" ]; then
		grep -rl "$1" "$2"
	else
		echo "Usage: grepf <text> <directory>"
	fi
}
_wiki(){
	firefox "https://wiki.archlinux.org/title/$1"
}
# search for package
alias wiki=_wiki
# bsp-layout set even
alias sctl='systemctl'
alias clr='clear'
alias fzv=_none
alias fdf=lazy_find
alias fzf=_fzf
alias grepf=_grep_files
alias fz='\fzf --preview "bat --style=header --theme=base16 --color=always --line-range :500 {}" --print0 | xargs -0 -o nvim'
alias grep='grep -n --color'
alias zn='nvim ~/.zshrc'
alias zs='source ~/.zshrc'
alias hg='history | grep'
alias h='history'
alias co='codium .'
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias findf='find . -type f'
alias findd='find . -type d'
alias pacman="sudo pacman"
#git
alias gitc='git clone'
alias gs='git status'
alias ga='git add'
alias gp='git pull'
alias gd='git diff'
alias gc='git commit -m'
alias gpo='git push origin'
#pacman & yay
alias yup='yay -Syu'
alias pup='pacman -Syu'
alias pcup='pacman -R $(pacman -Qtdq)' # one day this is gonna break my system
alias pc='pacman -Sc'
#disk & memory info
alias mem='free -h'
alias disk='df -h'
# power control
alias off='sudo shutdown -h now'
# network
alias nt='nmtui'
alias ntl='nmcli device wifi list'
alias ntc='nmcli device wifi connect'
alias nts='nmcli connection show'
alias ntd='nmcli device'
# file transf
alias rs='rsync -avz'
alias scp='scp -r'
#Go
alias gob='go build'
alias goi='go install'
alias gor='go run'
alias got='go test ./...'
alias god='go get -u'
alias goinit='go mod init'
alias gorv='go run -v'

#ZSH_THEME="amuse"
ZSH_THEME="dracula"
plugins=(git)

source /opt/nvs/nvs.sh
source $ZSH/oh-my-zsh.sh
