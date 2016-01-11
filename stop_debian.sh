#!/system/bin/sh

# stop debian script

source /data/local/debian_env_vars.sh

# stop debian services
deb_chroot /etc/init.d/rc 0

# sync data on disk
sync

# unmount everything
umount $ROOT/proc
umount $ROOT/sys
umount $ROOT/dev/pts
umount $ROOT/dev
umount $ROOT/tmp

grep /data/local/debian/mnt/android /proc/mounts | while read -r mount_point
do
    array=($mount_point)
    echo "try to unmount ${array[1]}"
    umount ${array[1]}
    echo "done"
done

umount $ROOT
