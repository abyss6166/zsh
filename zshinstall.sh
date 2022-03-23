#!/bin/bash

export ZSHUSER=$USER

if [ -f /etc/os-release ]; then
	. /etc/os-release
	OS=$NAME
	VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
fi

echo "Creating fonts directory"
cd /tmp && mkdir fonts && cd $_

echo "Downloading fonts"
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

#scp /mnt/E/Linux/zsh/Fonts/*.ttf /tmp/fonts

echo "Entering sudo mode to copy fonts"

if [[ $NAME = "Fedora" ]]; then
sudo su - <<EOF
dnf install -y git zsh zsh-autosuggestions zsh-syntax-highlighting
cd /usr/share/fonts/ && mkdir MesloMGS
cp /tmp/fonts/*.ttf /usr/share/fonts/MesloMGS
fc-cache
rm -r /tmp/fonts
scp -v /mnt/E/Linux/zsh/$NAME/aliasrc $HOME
chown $USER:$USER $HOME/aliasrc
su $USER
EOF

elif [[ $NAME = "void" ]]; then
sudo su - <<EOF
xbps-install -y git zsh zsh-autosuggestions zsh-syntax-highlighting
cp /tmp/fonts/*.ttf /usr/share/fonts/TTF
fc-cache
rm -r /tmp/fonts
scp -v /mnt/E/Linux/zsh/$NAME/aliasrc $HOME
chown $USER:$USER $HOME/aliasrc
su $USER
EOF

elif [[ $NAME = "Debian" ]] || [[ $NAME = "Ubuntu" ]] || [[ $NAME = "Linux Mint" ]]; then
sudo su - <<EOF
apt install -y git zsh zsh-autosuggestions zsh-syntax-highlighting
cd /usr/share/fonts/truetype && mkdir MesloMGS
cp /tmp/fonts/*.ttf /usr/share/fonts/truetype/MesloMGS
fc-cache
rm -r /tmp/fonts
scp -v /mnt/E/Linux/zsh/Debian/aliasrc $HOME
chown $USER:$USER $HOME/aliasrc
su $USER
EOF

elif [[ $NAME = "CentOS Linux" ]]; then
sudo su - <<EOF
yum install -y git zsh zsh-syntax-highlighting
cd /usr/share/fonts/ && mkdir MesloMGS
cp /tmp/fonts/*.ttf /usr/share/fonts/MesloMGS
fc-cache
rm -r /tmp/fonts
scp -v /mnt/E/Linux/zsh/CentOS/aliasrc $HOME
chown $USER:$USER $HOME/aliasrc
git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
su $USER
EOF

else
	echo "Operating system not identified"
	pause
fi

touch "$HOME/.cache/zshhistory"
echo "making directory for powerlevel"
mkdir ~/powerlevel10k && cd ~/powerlevel10k
echo "cloning git repository for powerlevel"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo "adding powerlevel theme to zshrc"
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

echo "opening terminal to configure zsh"
if [[ $NAME = "Ubuntu" ]] || [[ $NAME = "CentOS Linux" ]] || [[ $NAME = "Linux Mint" ]]; then
	gnome-terminal -q -- zsh
	read -p "press enter to resume"
elif [[ $NAME = "Fedora" ]]; then
	mate-terminal -e zsh
elif [[ $NAME = void ]]; then
	qterminal -e zsh
elif [[ $NAME = Debian ]]; then
	xfce4-terminal -e zsh
fi

sudo su - <<EOF
echo "copying .zshrc file"
scp -v /mnt/E/Linux/zsh/.zshrc $HOME
chown $USER:$USER $HOME/.zshrc
su $USER
EOF
