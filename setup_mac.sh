#!/bin/bash


DOTFILESDIR=$(dirname "$0")

function main() {
    install_brew
    install_firefox
    install_kitty
    install_node
    install_golang
    install_neovim
    install_tmux
    install_oh_my_zsh
    set_keyboard_preferences
    set_trackpad_preferences
    set_mouse_preferences
    set_clock_preferences
    install_bash_aliases
    install_zshrc_config
    install_git_config
    install_tmux_config
    install_fzf
    install_sdkman && install_java
}

function install_brew() {
    if ! command -v brew &> /dev/null
    then
        echo "Installing brew"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "brew already exists, skipping install."
    fi
}

function install_firefox() {
    if ! brew list firefox &> /dev/null
    then
        echo "Installing Firefox"
        brew install --cask firefox
    else
        echo "firefox already exists, skipping install."
    fi
}

function install_kitty() {
    if ! command -v kitty &> /dev/null
    then
        echo "Installing kitty"
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        mkdir -p ~/.config/kitty/
        cp $DOTFILESDIR/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf
    else
        echo "kitty already exists, skipping install."
    fi
}

function install_neovim() {
    if ! command -v nvim &> /dev/null
    then
        echo "Installing neovim."
        brew install neovim
    else
        echo "neovim already exists, skipping install."
    fi

    echo "Installing neovim config."
    mkdir -p "$HOME/.config/nvim/"
    _backup_file "$HOME/.config/nvim/init.vim"
    cp $DOTFILESDIR/.config/nvim/init.vim $HOME/.config/nvim/init.vim

    if [ -f "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim ]
    then
        echo "Vim-plug already exists, skipping install"
    else 
	    echo "Installing vim-plug."
	    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    fi
    nvim -c ":PlugClean" -c ":PlugInstall" 
    nvim -c ":LspInstall gopls" -c ":LspInstall bashls" -c ":LspInstall jdtls"
}

function install_golang() {
    if ! command -v go &> /dev/null
    then
        echo "Installing golang"
        brew install go
    else
        echo "golang already exists, skipping install."
    fi
}

function install_tmux() {
    if ! command -v tmux &> /dev/null
    then
        echo "Installing tmux"
        brew install tmux 
    else
        echo "tmux already exists, skipping install."
    fi
}



function install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "oh-my-zsh already exists, skipping install."
    else
        echo "Installing oh-my-zsh."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

function set_clock_preferences() {
    echo "Setting Mac clock preferences"
    defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  j:mm:ss a"
}


function set_trackpad_preferences() {
    echo "Setting Mac trackpad preferences."
    # tap-to-click enabled
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
}

function set_mouse_preferences() {
    echo "Setting Mac mouse preferences."
    # increase mouse sensitivity
    defaults write -g com.apple.mouse.scaling -int 2
}

function set_keyboard_preferences() {
    echo "Setting Mac keyboard preferences."
    defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
    defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
}

function install_bash_aliases() {
    echo "Installing bash aliases."
    _backup_file "$HOME/.bash_aliases"
    cp $DOTFILESDIR/.bash_aliases $HOME/.bash_aliases
}

function install_zshrc_config() {
    echo "Installing zshrc."
    _backup_file "$HOME/.zshrc"
    cp $DOTFILESDIR/.zshrc $HOME/.zshrc
    zsh "$HOME/.zshrc"
}

function install_git_config() {
    if [ -f "$HOME/.gitconfig" ]; then
        echo "git config already exists, skipping."
    else
        echo "Instaling git config."
        cp $DOTFILESDIR/.gitconfig $HOME/.gitconfig
    fi
}

function install_tmux_config() {
    echo "Instaling tmux config."
    _backup_file "$HOME/.tmux.conf"
    cp $DOTFILESDIR/.tmux.conf $HOME/.tmux.conf
}

function install_fzf() {
    echo "Instaling fzf."
    if ! command -v fzf &> /dev/null
    then
        echo "Installing fzf"
        brew install fzf
	$(brew --prefix)/opt/fzf/install --all --key-bindings --completion --update-rc
    else
        echo "fzf already exists, skipping install."
    fi
}

function install_node() {
    if ! command -v node &> /dev/null
    then
        echo "Installing node"
        brew install node
    else
        echo "node already exists, skipping install."
    fi

}

function _backup_file() {
    local source_file=$1
    if [ -f "$source_file" ]; then
        local fname="$source_file.bak.$(date -u +%s)"
        echo "$source_file already exists, backing up to $fname."
	cp $source_file $fname
    fi
}

function install_sdkman() {
    curl -s "https://get.sdkman.io" | bash
    source ~/.zshrc
}
 
function install_java() {
    sdk install java 17.0.5-zulu
    sdk install gradle
    sdk install maven
}

main
