echo "Installing shell goodies"

if [ ! -d $HOME/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d $HOME/.vim/pack/dist/start/vim-airline ]; then
  git clone https://github.com/vim-airline/vim-airline $HOME/.vim/pack/dist/start/vim-airline
  git clone https://github.com/vim-airline/vim-airline-themes $HOME/.vim/pack/dist/start/vim-airline-themes
fi


[ -f $HOME/.toprc ] || ln -s $HOME/.shell-goodies/dot-rc/toprc $HOME/.toprc
[ -f $HOME/.vimrc ] || ln -s $HOME/.shell-goodies/vim/vimrc $HOME/.vimrc
[ -f $HOME/.tmux.conf ] || ln -s $HOME/.shell-goodies/dot-rc/tmux.conf $HOME/.tmux.conf

sed -i "" 's/ZSH_THEME=".*"/ZSH_THEME="fabio"/' $HOME/.zshrc
sed -i "" 's/.*ZSH_CUSTOM=.*/ZSH_CUSTOM=$HOME\/.shell-goodies\/zsh/' $HOME/.zshrc
sed -i "" 's/plugins=(.*)/plugins=(dotenv)/' $HOME/.zshrc

grep -qe '^export EDITOR="vim"' $HOME/.zshrc || echo 'export EDITOR="vim"' >> $HOME/.zshrc
