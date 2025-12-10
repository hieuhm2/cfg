sudo apt update
sudo apt upgrade

# openvpn setup
sudo apt install apt-transport-https curl
mkdir -p /etc/apt/keyrings
sudo -i
curl -sSfL https://packages.openvpn.net/packages-repo.gpg >/etc/apt/keyrings/openvpn.asc

echo "deb [signed-by=/etc/apt/keyrings/openvpn.asc] https://packages.openvpn.net/openvpn3/debian jammy main" >>/etc/apt/sources.list.d/openvpn3.list

apt update
apt install -y openvpn3

# git setup
sudo apt install git -y

# nvim setup
cd Downloads
wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz
tar -xzvf nvim-linux-x86_64.tar.gz
sudo cp nvim-linux-x86_64 /opt/ -r
sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

## kickstart nvim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim


# zsh setup
sudo apt-get install zsh -y
sudo curl -L http://install.ohmyz.sh | sh
chsh -s $(which zsh)
# logout and login again

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

source ~/.zshrc
# vscode download
wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode.deb
sudo dpkg -i vscode.deb

# intellij download
# link down intellij
tar -xzf ideaIC-2025.2.2.tar.gz


# install java
wget https://download.oracle.com/java/21/archive/jdk-21.0.7_linux-x64_bin.deb -O jdk-21.0.7_linux-x64_bin.deb
sudo dpkg -i jdk-21.0.7_linux-x64_bin.deb 

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
