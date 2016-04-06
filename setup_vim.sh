#!/bin/bash

# copy the vimrc
cp .vimrc ~/.vimrc

# install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# install plugins
git clone https://github.com/ervandew/supertab.git ~/.vim/bundle/supertab/
git clone https://github.com/scrooloose/syntastic.git ~/.vim/bundle/syntastic/
git clone https://github.com/flazz/vim-colorschemes.git ~/.vim/bundle/vim-colorschemes/
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive
git clone https://github.com/tmhedberg/matchit.git ~/.vim/bundle/matchit

# install ctags
wget "http://downloads.sourceforge.net/project/ctags/ctags/5.8/ctags-5.8.tar.gz?r=http%3A%2F%2Fctags.sourceforge.net%2F&ts=1459972966&use_mirror=tenet" -O /tmp/ctags-5.8.tar.gz
tar xzf /tmp/ctags-5.8.tar.gz -C /tmp/
cd /tmp/ctags-5.8
./configure && make && make install
cd -
