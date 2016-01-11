#!/system/bin/sh

# start debian script

source /data/local/debian_env_vars.sh

mount_bind() {
    if [ -d $1 ]; then
        mkdir -p $ROOT/mnt/android/$1
        grep -q $ROOT/mnt/android/$1 /proc/mounts || \
        mount -o bind $1 $ROOT/mnt/android/$1
    fi
}

mount_bind /acct
mount_bind /app-cache
mount_bind /cache
mount_bind /data
mount_bind /dbdata

mount_bind /dev/cpuctl
mount_bind /efs
mount_bind /mnt/.lfs
mount_bind /mnt/asec
mount_bind /mnt/obb
mount_bind /mnt/secure/asec
mount_bind /mnt/sdcard/external_sd
mount_bind /mnt/sdcard/external_sd/.android_secure
mount_bind /mnt/secure/.android_secure
mount_bind /mnt/shell/emulated
mount_bind /pds
mount_bind /sd-ext
mount_bind /sqlite_stmt_journals
mount_bind /storage/emulated/0
mount_bind /storage/emulated/legacy
mount_bind /storage/extSdCard
mount_bind /storage/sdcard0
mount_bind /storage/sdcard1
mount_bind /storage/usbdisk
mount_bind /sys/kernel/debug
mount_bind /system

# remove dangerous scripts from Debian's rc0.d
for script in halt hwclock.sh sendsigs umountfs umountroot; do
    if [ -e $ROOT/etc/rc0.d/*$script ]; then
        deb_chroot /usr/sbin/update-rc.d -f $script remove && \
        echo "Removed '$script' from /etc/rc0.d/"
    fi
done

if [ -e /etc/rc6.d/*reboot ]; then
    deb_chroot /usr/sbin/update-rc.d -f reboot remove && \
    echo "Removed 'reboot' from /etc/rc6.d/"
fi

deb_chroot /etc/init.d/rc 2
