#!/bin/bash
clear
/bin/echo -e '\n\n\e[1;36mRUNNING ARCH ACETATE as in TRENBOLONE ACETATE... :)\e[0m'
sleep 1
/bin/echo -e '\n\n\e[1;36mDOWNLOADING REQUIRED SCRIPTS, PLEASE WAIT..!!\e[0m'
sleep 1
curl https://raw.githubusercontent.com/nawthing/arch-acetate/master/chrootbuild > chrootbuild
clear
# Function to gather partition information
PART_INT() {
    # Display initial messages and gather necessary partition information
    ping -c 1 archlinux.org
    /bin/echo -e '\n\n\e[1;36mSTARTING SCRIPT...\e[0m'
    sleep 1
    /bin/echo -e '\n\n\e[1;36mSETTING FONT...\e[0m'
    setfont ter-132b
    clear
    /bin/echo -e '\n\n\e[1;36mENTER THE FOLLOWING PARAMETERS...\e[0m'
    timedatectl set-ntp true
    echo -e '\n'                                        
    lsblk
    echo -e '\n'                                        
    read -p "Drive name (eg: sda, vda, nvme0): " DRIVE
    cfdisk "/dev/$DRIVE"
    clear
    echo -e '\n'                                        
    lsblk "/dev/$DRIVE"
    echo -e '\n'                                        
    read -p "EFI partition: " EFI
    echo -e '\n'                                        
    read -p "Root partition: " ROOT
    echo -e '\n'                                        
    read -p "Home partition: " HOME
}

# Function to format drives
FRT_MAIN() {
    # Format specified drives with appropriate file systems and mount points
    clear && /bin/echo -e '\n\n\e[1;32mFormatting Drives...\e[0m'
    echo -e '\n'                                        
    mkfs.fat -F32 "/dev/$EFI" 
    mkfs.ext4 "/dev/$ROOT"
    mkfs.ext4 "/dev/$HOME"
    mount "/dev/$ROOT" /mnt
    mkdir -p /mnt/boot/efi 
    mkdir /mnt/home
    mount "/dev/$EFI" /mnt/boot/efi
    mount "/dev/$HOME" /mnt/home
}

# Function to set up system configurations
SYS_GRD() {
    # Identify CPU type and update keyring, install essential packages
    model=$(lscpu | grep 'Model name')

    case "$model" in
        *Intel*) CPUUCODE="intel-ucode" ;;
        *AMD*) CPUUCODE="amd-ucode" ;;
    esac

    echo -e '\n'                                        
    printf "$CPUUCODE"
    echo -e '\n'                                        
    /bin/echo -e '\n\n\e[1;36mUPDATING KEYRING...\e[0m'
    pacman -Sy archlinux-keyring --noconfirm
    pacstrap /mnt base base-devel linux linux-firmware vim git "$CPUUCODE"
    genfstab -U /mnt >> /mnt/etc/fstab
}

# Function to execute operations within the chroot environment
CHR_CRY() {
    # Perform operations within the chroot environment
    cp chrootbuild /mnt/chrootbuild 
    chmod +x /mnt/chrootbuild 
    arch-chroot /mnt bash chrootbuild && rm /mnt/chrootbuild
}

# Function to close and finalize installation
CLOSG(){
    # Unmount and display final installation message before rebooting
    umount -R /mnt
    clear 
    /bin/echo -e '\n\n\e[1;32mINSTALLATION COMPLETED!\e[0m'
    sleep 1
    /bin/echo -e '\n\n\e[1;32mREBOOTING IN 3...\e[0m'
    sleep 1
    /bin/echo -e '\n\n\e[1;32mREBOOTING IN 2...\e[0m'
    sleep 1
    /bin/echo -e '\n\n\e[1;32mREBOOTING IN 1...\e[0m'
    sleep 1
    /bin/echo -e '\n\n\e[1;31mREBOOTING NOW...\e[0m'
    reboot
}

# Starting point
PART_INT
FRT_MAIN
SYS_GRD
CHR_CRY
CLOSG
