#!/usr/bin/env zsh

# Clone using
# git clone https://github.com/fabiojmendes/shell-goodies .shell-goodies

VIM_PACK="$HOME/.vim/pack/dist/start"

install_pack() {
  local url=$1
  local target=$VIM_PACK/$(basename $url)
  if [[ ! -d $target ]]; then
    git clone $url $target
    vim -u NONE -c ":helptags $target/doc" -c q
  else
    echo "$(basename $target) already exists"
  fi
}

install_link() {
  local link=$1
  local target=$HOME/.$(basename $link)
  if [[ -f $target ]]; then
    echo "$target already exists"
  else
    ln -s $link $target
  fi
}

echo "Installing shell goodies"

if [[ ! -n "$ZSH" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

install_pack "https://github.com/vim-airline/vim-airline"
install_pack "https://github.com/vim-airline/vim-airline-themes"
install_pack "https://github.com/preservim/nerdtree"

if [[ $(uname) == "Linux" ]]; then
  install_link ".shell-goodies/dot-rc/toprc"
fi
install_link ".shell-goodies/vim/vimrc"
install_link ".shell-goodies/dot-rc/tmux.conf"
install_link ".shell-goodies/dot-rc/gdbinit"

if [[ ! -f $HOME/.gdb_dashboard ]]; then
  echo "Installing gdb dashboard"
  curl -L -o $HOME/.gdb_dashboard https://git.io/.gdbinit
fi

[[ $(uname) == "Linux" ]] && INPL="-i.bkp" || INPL="-i .bkp"
sed $INPL \
  -e 's/ZSH_THEME=".*"/ZSH_THEME="fabio"/' \
  -e 's/# ZSH_CUSTOM=.*/ZSH_CUSTOM=$HOME\/.shell-goodies\/zsh/' \
  -e 's/^plugins=(.*)/plugins=(dotenv)/' \
  $HOME/.zshrc

grep -qe '^export EDITOR="vim"' $HOME/.zshrc || echo 'export EDITOR="vim"' >> $HOME/.zshrc

echo "Done"
