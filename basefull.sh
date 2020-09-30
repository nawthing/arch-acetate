ping -c 1 protonmail.com

timedatectl set-ntp true

cfdisk

mkfs.fat -F32 /dev/sda1 

mkfs.ext4 /dev/sda2

#mkfs.ext4 /dev/sda3

mount /dev/sda2 /mnt

mkdir -p /mnt/boot/efi 

#mkdir /mnt/home

mount /dev/sda1 /mnt/boot/efi

#mount /dev/sda3 /mnt/home

pacstrap /mnt base base-devel linux linux-firmware vim git #amd-ucode intel-ucode

genfstab -U /mnt >> /mnt/etc/fstab

cp base-chroot.sh /mnt/base-chroot.sh 

chmod +x /mnt/base-chroot.sh

arch-chroot /mnt bash base-chroot.sh && rm /mnt/base-chroot.sh

umount -R /mnt

reboot

