sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/vim-airline/vim-airline $HOME/.vim/pack/dist/start/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes $HOME/.vim/pack/dist/start/vim-airline-themes

ln -s $HOME/.shell-goodies/dot-rc/toprc $HOME/.toprc
ln -s $HOME/.shell-goodies/vim/vimrc $HOME/.vimrc
ln -s $HOME/.shell-goodies/dot-rc/tmux.conf $HOME/.tmux.conf
