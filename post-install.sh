# create a new user
pacman -Syu sudo
useradd --create-home shubh
passwd shubh
usermod -aG wheel shubh
cd /home/shubh

# install essential packages
pacman -S --noconfirm --needed base-devel git wget curl neofetch htop linux linux-firmware tmux tor python zsh neovim clang firefox 
# install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

# install packages from AUR
yay -S --noconfirm --needed brave spotify discord visual-studio-code-bin

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install minimal gnome
pacman -S --noconfirm --needed gnome-shell gnome-terminal gnome-tweak-tool gnome-control-center gdm gnome-keyring networkmanager

# enable services
systemctl enable gdm
systemctl enable NetworkManager

# install nvidia drivers
pacman -S --noconfirm --needed nvidia nvidia-utils nvidia-settings

# setup wayland and xwayland
echo "--enable-features=WaylandWindowDecorations
--ozone-platform-hint=auto" >> ~/.config/electron-flags.conf

pacman -S xorg-xwayland --noconfirm --needed

# remind me to add nvidia drm modules in /etc/default/grub
echo "Add nvidia drm modules in /etc/default/grub"

