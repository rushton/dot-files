#!/bin/bash

function main() {
    install_brew
    install_firefox
    install_kitty
    install_nvim
    install_golang
    install_tmux
    install_oh_my_zsh
    set_keyboard_preferences
    set_trackpad_preferences
    set_dock_preferences
}
function install_brew() {
    if ! command -v brew &> /dev/null
    then
        echo "Installing brew"
        bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
    else
        echo "kitty already exists, skipping install."
    fi
}

function install_nvim() {
    if ! command -v nvim &> /dev/null
    then
        echo "Installing neovim"
        brew install neovim
    else
        echo "neovim already exists, skipping install."
    fi
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
    if [ -d ".oh-my-zsh" ]; then
        echo "oh-my-zsh already exists, skipping install."
    else
        echo "Installing oh-my-zsh."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

function set_dock_preferences() {
    echo "Setting dock preferences."
    echo '
tell application "System Events" to set the autohide of the dock preferences to true
tell application "System Events" to set the screen edge of the dock preferences to left

' > /tmp/hide_dock_script.scpt
    osascript /tmp/hide_dock_script.scpt
    rm /tmp/hide_dock_script.scpt
}


function set_trackpad_preferences() {
    echo "Setting trackpad preferences."
    # tap-to-click enabled
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
}

function set_keyboard_preferences() {
    echo "Setting keyboard preferences."
    defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
    defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
}

main
