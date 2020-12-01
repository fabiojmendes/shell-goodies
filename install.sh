echo "Installing shell goodies"

if [ ! -n "$ZSH" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

VIM_PACK="$HOME/.vim/pack/dist/start"
if [ ! -d $VIM_PACK/vim-airline ]; then
  git clone https://github.com/vim-airline/vim-airline $VIM_PACK/vim-airline
  git clone https://github.com/vim-airline/vim-airline-themes $VIM_PACK/vim-airline-themes
fi


[ -f $HOME/.toprc ] || ln -s .shell-goodies/dot-rc/toprc $HOME/.toprc
[ -f $HOME/.vimrc ] || ln -s .shell-goodies/vim/vimrc $HOME/.vimrc
[ -f $HOME/.tmux.conf ] || ln -s .shell-goodies/dot-rc/tmux.conf $HOME/.tmux.conf

[ "$(uname)" = "Linux" ] && INPL="-i" || INPL="-i .bkp"
sed $INPL \
  -e 's/ZSH_THEME=".*"/ZSH_THEME="fabio"/' \
  -e 's/# ZSH_CUSTOM=.*/ZSH_CUSTOM=$HOME\/.shell-goodies\/zsh/' \
  -e 's/^plugins=(.*)/plugins=(dotenv)/' \
  $HOME/.zshrc

grep -qe '^export EDITOR="vim"' $HOME/.zshrc || echo 'export EDITOR="vim"' >> $HOME/.zshrc
