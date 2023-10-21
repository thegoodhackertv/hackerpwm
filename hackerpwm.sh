#!/bin/bash

# Check if current user is root
if [ "$UID" -eq 0 ]; then
    echo "Cannot run as root."
    exit 1
else
    # Checks for sudo
    if [ -n "$SUDO_USER" ]; then
        echo "Do not use sudo"
        exit 1
    fi
fi

echo "
██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ ██████╗ ██╗    ██╗███╗   ███╗
██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗██╔══██╗██║    ██║████╗ ████║
███████║███████║██║     █████╔╝ █████╗  ██████╔╝██████╔╝██║ █╗ ██║██╔████╔██║
██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗██╔═══╝ ██║███╗██║██║╚██╔╝██║
██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║██║     ╚███╔███╔╝██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝      ╚══╝╚══╝ ╚═╝     ╚═╝
"
sleep 2
echo -e "\thackerpwm - Hacker environment automation script."
echo -e "\t\tAndrés J. Moreno (Aka. TheGoodHacker)"
sleep 3
echo -e "\nInstallation will begin soon..\n"
sleep 5

RPATH=`pwd`

# update and upgrade all
sudo apt update
sudo apt upgrade -y

# install packages 
sudo apt install -y git vim feh scrot scrub zsh rofi xclip xsel bat locate neofetch wmname acpi bspwm sxhkd \
imagemagick ranger kitty tmux python3-pip font-manager lsd bpython open-vm-tools-desktop open-vm-tools # snapd

# install environment dependencies
sudo apt install -y build-essential xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev \
libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev

# install polybar requirements
sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev \
libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev \
libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev \
libmpdclient-dev libuv1-dev libnl-genl-3-dev

# Install picom dependencies
sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev \
libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev \
libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev \
uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev

# install fonts
mkdir /tmp/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip -O /tmp/fonts/Hack.zip
unzip /tmp/fonts/Hack.zip -d /tmp/fonts
font-manager -i /tmp/fonts/*.ttf

# install ohmyzsh
rm -rf ~/.oh-my-zsh
echo -e "\nType exit after zsh is launched!\n"
sleep 5
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
rm -f ~/.p10k.zsh
cp -v $RPATH/CONFIGS/p10k.zsh ~/.p10k.zsh

# install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
rm -f ~/.zshrc
# install zsh-autocomplete?
cp -v $RPATH/CONFIGS/zshrc ~/.zshrc

# .tmux
rm -rf ~/.tmux
git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s -f ~/.tmux/.tmux.conf ~/
cp -v $RPATH/CONFIGS/tmux.conf.local ~/.tmux.conf.local

#nvim
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz -O /tmp/nvim-linux64.tar.gz
sudo tar xzvf /tmp/nvim-linux64.tar.gz --directory=/opt
sudo ln -s /opt/nvim-linux64/bin/nvim /usr/bin/nvim
sudo rm -f /opt/nvim-linux64.tar.gz

#nvchad - needs work. Block cursor and user interaction
# git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

# install kitty terminal
cat $RPATH/kitty-installer.sh | sh /dev/stdin
# ~/.local/kitty.app/bin/kitty

# Clone polybar & picom repos
mkdir ~/github
git clone --recursive https://github.com/polybar/polybar ~/github/polybar
git clone https://github.com/ibhagwan/picom.git ~/github/picom

# install polybar
cd ~/github/polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install

# install polybar themes
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git ~/github/polybar-themes
chmod +x ~/github/polybar-themes/setup.sh
cd ~/github/polybar-themes
echo 1 | ./setup.sh

# install picom
cd ~/github/picom
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install

# Change timezone
# To list timezones run: timedatectl list-timezones
sudo timedatectl set-timezone "Europe/Madrid"

mkdir ~/screenshots
# copy all config files
cp -rv $RPATH/CONFIGS/config/* ~/.config/

# copy scripts
cp -rv $RPATH/SCRIPTS/* ~/.config/polybar/forest/scripts/
sudo ln -s ~/.config/polybar/forest/scripts/target.sh /usr/bin/target
sudo ln -s ~/.config/polybar/forest/scripts/screenshot.sh /usr/bin/screenshot

# copy wallpapers
mkdir ~/Wallpapers/
cp -rv $RPATH/WALLPAPERS/* ~/Wallpapers/

# Set execution perms
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/bspwm/scripts/bspwm_resize
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/polybar/forest/scripts/target.sh
chmod +x ~/.config/polybar/forest/scripts/screenshot.sh

# Select rofi theme
#rofi-theme-selector

# Enable tap to click and change mousepad scroll direction (laptops) https://cravencode.com/post/essentials/enable-tap-to-click-in-i3wm/
#sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee <<'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
#Section "InputClass"
#        Identifier "touchpad"
#        MatchIsTouchpad "on"
#        Driver "libinput"
#        Option "Tapping" "on"
#        Option "NaturalScrolling" "on"
#EndSection
#
#EOF

# Clean files
rm -rf ~/github
rm -rf $RPATH
sudo apt autoremove -y

echo -e "\n[+] Done. Have fun!\n"
echo -e "[!] Please reboot..\n"
