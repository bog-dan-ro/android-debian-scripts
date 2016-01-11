#!/system/bin/sh

# this fills script /data/local/debian_image_vars with the image dev block path and with debian ROOT path
# needed by start_debian.sh/stop_debian.sh

#default dev block
IMG_DEV=/dev/block/sda1

#default debian image root path
ROOT=/data/local/debian

exit_error() {
    echo $1
    exit 1
}

if [ $# -ge 1 ]; then
    IMG_DEV=$1

    if [ $# -ge 2 ]; then
        ROOT=$2
    fi
fi

if [ ! -e $IMG_DEV ]; then
    exit_error "Can't find $IMG_DEV"
fi

echo "Setting:\n\tIMAGE_DEV=${IMG_DEV}\n\tROOT=${ROOT}\n"
echo "IMAGE_DEV=$IMG_DEV\nROOT=$ROOT\n" > /data/local/debian_image_vars || exit_error "Can't create /data/local/debian_image_vars"

cp $ROOT/android/debian_env_vars.sh /data/local/debian_env_vars.sh || exit_error "Can't copy debian_env_vars.sh"

for script in start_debian.sh stop_debian.sh chroot_debian.sh; do
    cp $ROOT/android/$script /data/local/$script || exit_error "Can't copy $script"
    chmod 755 /data/local/$script || exit_error "Can't chmod $script"
done

rm $ROOT/etc/mtab
ln -s /proc/mounts $ROOT/etc/mtab || exit_error "Can't ln /proc/mounts"

if grep -q '/data/local/start_debian.sh' /system/etc/mkshrc; then
 exit 0
fi

exit 0
