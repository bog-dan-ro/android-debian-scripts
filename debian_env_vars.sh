#!/system/bin/sh

# start debian script

if [ ! -e /data/local/debian_image_vars ]; then
    echo "setup_debian.sh must be ran first"
    echo "also this script can't be run from debian's chroot"
    exit 0
fi

source /data/local/debian_image_vars

# mount debian image
if [ ! -e $ROOT/root ]; then
    mount -t ext4 $IMAGE_DEV $ROOT
fi

cd $ROOT
# mount proc, sys, dev, etc
if [ ! -e sys/kernel ]; then
    mount -t proc proc proc
    mount -t sysfs sysfs sys
    mount -t devpts devpts dev/pts
    mount -t tmpfs tmpfs tmp
    mount -o bind /dev dev
fi

export TERM=linux
export HOSTNAME=debian
export HOME=/root
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/vendor/bin:/system/sbin:/system/bin:/system/xbin
export USER=root

# helper function to run stuff inside debian chroot
deb_chroot() {
    cd $ROOT
    export TERM=linux
    export HOSTNAME=debian
    export HOME=/root
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/vendor/bin:/system/sbin:/system/bin:/system/xbin
    export USER=root
    LD_LIBRARY_PATH=$ROOT/lib:$ROOT/lib/aarch64-linux-gnu:$ROOT/usr/lib:$ROOT/usr/lib/aarch64-linux-gnu ./lib/ld-linux-*.so* usr/sbin/chroot $ROOT $@
}
