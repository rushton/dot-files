#!/bin/bash

# copy the vimrc
cp .vimrc ~/.vimrc

# install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

ln -s ~/.vim ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim

# install plugins
git clone https://github.com/ervandew/supertab.git ~/.vim/bundle/supertab/
git clone https://github.com/scrooloose/syntastic.git ~/.vim/bundle/syntastic/
git clone https://github.com/flazz/vim-colorschemes.git ~/.vim/bundle/vim-colorschemes/
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive
git clone https://github.com/tmhedberg/matchit.git ~/.vim/bundle/matchit
