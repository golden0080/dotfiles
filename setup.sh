# Some basic tools
sudo apt install -y git wget
sudo apt install -y silversearcher-ag

# Download and setup spacemacs, need emacs25
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
ln -s $(HOME)/dotfiles/dot.spacemacs ~/.spacemacs
sudo apt install -y python3-pip

# Download and install `fd`
FD_DL_URL=https://github.com/sharkdp/fd/releases/download/v7.0.0/fd-musl_7.0.0_amd64.deb
rm /tmp/fd.deb
wget $(FD_DL_URL) -o /tmp/fd.deb
sudo dpkg -i /tmp/fd.deb

# TODO(gh): optionally install stormssh
sudo pip3 install stormssh

# TODO(gh): install fzf, optionally
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# TODO(gh): insert necessary lines into ~/.bash_profile
