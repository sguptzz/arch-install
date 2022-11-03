# Verify the boot mode
if [ -f /sys/firmware/efi/efivars ]; then
    echo "EFI boot mode detected"
else
    echo "BIOS boot mode detected"
fi

# ping google.com
ping -c 3 google.com

# Update the system clock
timedatectl set-ntp true

#Verify the network interface
ip link

#Verify the network interface configuration
ip addr

# partition the disk
echo "partioning the disk"
parted -s /dev/sda mklabel gpt
parted -s /dev/sda mkpart ESP fat32 1MiB 513MiB
parted -s /dev/sda set 1 boot on
parted -s /dev/sda mkpart primary ext4 513MiB 100%
	
# format the partitions

echo "formatting the partitions"
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# mount the file systems
echo "mounting the file systems"
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# install the base packages
echo "installing the base packages"
pacstrap /mnt base base-devel linux linux-firmware vim

# generate the fstab file
echo "generating the fstab file"
genfstab -U /mnt >> /mnt/etc/fstab

# change root into the new system
echo "changing root into the new system"
arch-chroot /mnt

# set the time zone
echo "setting the time zone"
ln -sf /usr/share/zoneinfo/India/Kolkata /etc/localtime

# generate the /etc/adjtime file
echo "generating the /etc/adjtime file"
hwclock --systohc --utc

# set the locale
echo "setting the locale"
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# set the hostname
echo "setting the hostname"
echo "archlinux" > /etc/hostname

# set the root password
echo "setting the root password"
passwd

# install the bootloader
echo "installing the bootloader"
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

# enable the NetworkManager service
echo "enabling the NetworkManager service"
systemctl enable NetworkManager

# exit the chroot environment
echo "exiting the chroot environment"
exit

# unmount the file systems
echo "unmounting the file systems"
umount -R /mnt

# reboot the system
echo "rebooting the system"
reboot

