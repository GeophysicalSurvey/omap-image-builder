#!/bin/bash -e

time=$(date +%Y-%m-%d)
mirror_dir="/var/www/html/rcn-ee.us/rootfs/bb.org/testing"
DIR="$PWD"

git pull --no-edit https://github.com/beagleboard/image-builder master

export apt_proxy=apt-proxy:3142/

if [ -d ./deploy ] ; then
	sudo rm -rf ./deploy || true
fi

if [ ! -f jenkins.build ] ; then
./RootStock-NG.sh -c bb.org-debian-jessie-console-v4.4
./RootStock-NG.sh -c bb.org-debian-jessie-lxqt-2gb-v4.4
./RootStock-NG.sh -c bb.org-debian-jessie-lxqt-4gb-v4.4
./RootStock-NG.sh -c bb.org-debian-jessie-lxqt-4gb-xm

./RootStock-NG.sh -c seeed-debian-jessie-lxqt-4gb-v4.4
./RootStock-NG.sh -c seeed-debian-jessie-iot-v4.4
./RootStock-NG.sh -c bb.org-debian-jessie-oemflasher

./RootStock-NG.sh -c machinekit-debian-stretch
./RootStock-NG.sh -c bb.org-debian-stretch-console-v4.14
./RootStock-NG.sh -c bb.org-debian-stretch-iot-v4.14
./RootStock-NG.sh -c bb.org-debian-stretch-lxqt-2gb-v4.14
./RootStock-NG.sh -c bb.org-debian-stretch-lxqt-v4.14
./RootStock-NG.sh -c bb.org-debian-stretch-lxqt-tidl-v4.14
./RootStock-NG.sh -c bb.org-debian-stretch-lxqt-xm
./RootStock-NG.sh -c bb.org-debian-stretch-oemflasher-v4.14

./RootStock-NG.sh -c bb.org-debian-buster-console-v4.19
./RootStock-NG.sh -c bb.org-debian-buster-iot-v4.19
./RootStock-NG.sh -c bb.org-debian-buster-lxqt-v4.19

./RootStock-NG.sh -c bb.org-ubuntu-bionic-ros-iot-v4.19

else
	mkdir -p ${DIR}/deploy/ || true
fi

       debian_jessie_console="debian-8.11-console-armhf-${time}"
      debian_jessie_lxqt_2gb="debian-8.11-lxqt-2gb-armhf-${time}"
      debian_jessie_lxqt_4gb="debian-8.11-lxqt-4gb-armhf-${time}"
   debian_jessie_lxqt_xm_4gb="debian-8.11-lxqt-xm-4gb-armhf-${time}"
    debian_jessie_oemflasher="debian-8.11-oemflasher-armhf-${time}"

     debian_jessie_seeed_iot="debian-8.11-seeed-iot-armhf-${time}"
debian_jessie_seeed_lxqt_4gb="debian-8.11-seeed-lxqt-4gb-armhf-${time}"

   debian_stretch_machinekit="debian-9.11-machinekit-armhf-${time}"
      debian_stretch_console="debian-9.11-console-armhf-${time}"
          debian_stretch_iot="debian-9.11-iot-armhf-${time}"
     debian_stretch_lxqt_2gb="debian-9.11-lxqt-2gb-armhf-${time}"
         debian_stretch_lxqt="debian-9.11-lxqt-armhf-${time}"
    debian_stretch_lxqt_tidl="debian-9.11-lxqt-tidl-armhf-${time}"
      debian_stretch_lxqt_xm="debian-9.11-lxqt-xm-armhf-${time}"
      debian_stretch_wayland="debian-9.11-wayland-armhf-${time}"
   debian_stretch_oemflasher="debian-9.11-oemflasher-armhf-${time}"

          debian_buster_tiny="debian-10.1-tiny-armhf-${time}"
       debian_buster_console="debian-10.1-console-armhf-${time}"
    debian_buster_console_xm="debian-10.1-console-xm-armhf-${time}"
           debian_buster_iot="debian-10.1-iot-armhf-${time}"
     debian_buster_gobot_iot="debian-10.1-gobot-iot-armhf-${time}"
       debian_buster_efi_iot="debian-10.1-efi-iot-armhf-${time}"
          debian_buster_lxqt="debian-10.1-lxqt-armhf-${time}"

       ubuntu_bionic_ros_iot="ubuntu-18.04.3-ros-iot-armhf-${time}"

xz_img="xz -T3 -z -8"
xz_tar="xz -T4 -z -8"

beaglebone="--dtb beaglebone --rootfs_label rootfs --hostname beaglebone --enable-cape-universal"
pru_rproc_v44ti="--enable-uboot-pru-rproc-44ti"
pru_rproc_v414ti="--enable-uboot-pru-rproc-414ti"
pru_rproc_v419ti="--enable-uboot-pru-rproc-419ti"

beagle_xm="--dtb omap3-beagle-xm --rootfs_label rootfs --hostname beagleboard"

beagle_x15="--dtb am57xx-beagle-x15 --rootfs_label rootfs --hostname beaglebone"

cat > ${DIR}/deploy/gift_wrap_final_images.sh <<-__EOF__
#!/bin/bash

wait_till_Xgb_free () {
        memory=16384
        free_memory=\$(free --mega | grep Mem | awk '{print \$7}')
        until [ "\$free_memory" -gt "\$memory" ] ; do
                free_memory=\$(free --mega | grep Mem | awk '{print \$7}')
                echo "have [\$free_memory] need [\$memory]"
                sleep 10
        done
}

copy_base_rootfs_to_mirror () {
        wait_till_Xgb_free
        if [ -d ${mirror_dir}/ ] ; then
                if [ ! -d ${mirror_dir}/${time}/\${blend}/ ] ; then
                        mkdir -p ${mirror_dir}/${time}/\${blend}/ || true
                fi
                if [ -d ${mirror_dir}/${time}/\${blend}/ ] ; then
                        if [ ! -f ${mirror_dir}/${time}/\${blend}/\${base_rootfs}.tar.xz ] ; then
                                cp -v \${base_rootfs}.tar ${mirror_dir}/${time}/\${blend}/
                                cd ${mirror_dir}/${time}/\${blend}/
                                ${xz_tar} \${base_rootfs}.tar && sha256sum \${base_rootfs}.tar.xz > \${base_rootfs}.tar.xz.sha256sum &
                                cd -
                        fi
                fi
        fi
}

archive_base_rootfs () {
        if [ -d ./\${base_rootfs} ] ; then
                rm -rf \${base_rootfs} || true
        fi
        if [ -f \${base_rootfs}.tar ] ; then
                copy_base_rootfs_to_mirror
        fi
}

extract_base_rootfs () {
        if [ -d ./\${base_rootfs} ] ; then
                rm -rf \${base_rootfs} || true
        fi

        if [ -f \${base_rootfs}.tar.xz ] ; then
                tar xf \${base_rootfs}.tar.xz
        fi

        if [ -f \${base_rootfs}.tar ] ; then
                tar xf \${base_rootfs}.tar
        fi
}

copy_img_to_mirror () {
        wait_till_Xgb_free
        if [ -d ${mirror_dir} ] ; then
                if [ ! -d ${mirror_dir}/${time}/\${blend}/ ] ; then
                        mkdir -p ${mirror_dir}/${time}/\${blend}/ || true
                fi
                if [ -d ${mirror_dir}/${time}/\${blend}/ ] ; then
                        if [ -f \${wfile}.bmap ] ; then
                                mv -v \${wfile}.bmap ${mirror_dir}/${time}/\${blend}/
                                sync
                        fi
                        if [ ! -f ${mirror_dir}/${time}/\${blend}/\${wfile}.img.zx ] ; then
                                mv -v \${wfile}.img ${mirror_dir}/${time}/\${blend}/
                                sync
                                if [ -f \${wfile}.img.xz.job.txt ] ; then
                                        mv -v \${wfile}.img.xz.job.txt ${mirror_dir}/${time}/\${blend}/
                                        sync
                                fi
                                cd ${mirror_dir}/${time}/\${blend}/
                                ${xz_img} \${wfile}.img && sha256sum \${wfile}.img.xz > \${wfile}.img.xz.sha256sum &
                                cd -
                        fi
                fi
        fi
}

archive_img () {
        if [ -f \${wfile}.img ] ; then
                if [ ! -f \${wfile}.bmap ] ; then
                        if [ -f /usr/bin/bmaptool ] ; then
                                bmaptool create -o \${wfile}.bmap \${wfile}.img
                        fi
                fi
                copy_img_to_mirror
        fi
}

generate_img () {
        if [ -d \${base_rootfs}/ ] ; then
                cd \${base_rootfs}/
                echo "./setup_sdcard.sh \${options}"
                sudo ./setup_sdcard.sh \${options}
                sudo chown 1000:1000 *.img || true
                sudo chown 1000:1000 *.job.txt || true
                mv *.img ../ || true
                mv *.job.txt ../ || true
                cd ..
        fi
}

###DEBIAN JESSIE: console
base_rootfs="${debian_jessie_console}" ; blend="console" ; extract_base_rootfs

options="--img-1gb am57xx-\${base_rootfs}               ${beagle_x15}"                                   ; generate_img
options="--img-1gb am57xx-eMMC-flasher-\${base_rootfs}  ${beagle_x15} --emmc-flasher"                    ; generate_img
options="--img-1gb bone-\${base_rootfs}                 ${beaglebone} ${pru_rproc_v44ti}"                ; generate_img
options="--img-1gb bone-eMMC-flasher-\${base_rootfs}    ${beaglebone} ${pru_rproc_v44ti} --emmc-flasher" ; generate_img

###DEBIAN JESSIE: lxqt-2gb
base_rootfs="${debian_jessie_lxqt_2gb}" ; blend="lxqt-2gb" ; extract_base_rootfs

options="--img-2gb bone-\${base_rootfs}                 ${beaglebone} ${pru_rproc_v44ti}"                ; generate_img
options="--img-2gb bone-eMMC-flasher-\${base_rootfs}    ${beaglebone} ${pru_rproc_v44ti} --emmc-flasher" ; generate_img

###DEBIAN JESSIE: lxqt-4gb
base_rootfs="${debian_jessie_lxqt_4gb}" ; blend="lxqt-4gb" ; extract_base_rootfs

options="--img-4gb am57xx-\${base_rootfs}               ${beagle_x15}"                                   ; generate_img
options="--img-4gb am57xx-eMMC-flasher-\${base_rootfs}  ${beagle_x15} --emmc-flasher"                    ; generate_img
options="--img-4gb bone-\${base_rootfs}                 ${beaglebone} ${pru_rproc_v44ti}"                ; generate_img
options="--img-4gb bone-eMMC-flasher-\${base_rootfs}    ${beaglebone} ${pru_rproc_v44ti} --emmc-flasher" ; generate_img

###DEBIAN JESSIE: lxqt-xm
base_rootfs="${debian_jessie_lxqt_xm_4gb}" ; blend="lxqt-xm-4gb" ; extract_base_rootfs

options="--img-4gb bbxm-\${base_rootfs}  ${beagle_xm}" ; generate_img

###DEBIAN JESSIE: Seeed iot
base_rootfs="${debian_jessie_seeed_iot}" ; blend="seeed-iot" ; extract_base_rootfs

options="--img-4gb bone-\${base_rootfs}  ${beaglebone}" ; generate_img

###DEBIAN JESSIE: Seeed lxqt-4gb
base_rootfs="${debian_jessie_seeed_lxqt_4gb}" ; blend="seeed-lxqt-4gb" ; extract_base_rootfs

options="--img-4gb bone-\${base_rootfs}  ${beaglebone}" ; generate_img

###DEBIAN STRETCH: machinekit
base_rootfs="${debian_stretch_machinekit}" ; blend="stretch-machinekit" ; extract_base_rootfs

options="--img-4gb bone-\${base_rootfs} ${beaglebone}" ; generate_img

###DEBIAN STRETCH: console
base_rootfs="${debian_stretch_console}" ; blend="stretch-console" ; extract_base_rootfs

options="--img-1gb am57xx-\${base_rootfs}               ${beagle_x15}"                                    ; generate_img
options="--img-1gb am57xx-eMMC-flasher-\${base_rootfs}  ${beagle_x15} --emmc-flasher"                     ; generate_img
options="--img-1gb bone-\${base_rootfs}                 ${beaglebone} ${pru_rproc_v414ti}"                ; generate_img
options="--img-1gb bone-eMMC-flasher-\${base_rootfs}    ${beaglebone} ${pru_rproc_v414ti} --emmc-flasher" ; generate_img

###DEBIAN STRETCH: iot
base_rootfs="${debian_stretch_iot}" ; blend="stretch-iot" ; extract_base_rootfs

options="--img-4gb am57xx-\${base_rootfs}               ${beagle_x15}"                                    ; generate_img
options="--img-4gb am57xx-eMMC-flasher-\${base_rootfs}  ${beagle_x15} --emmc-flasher"                     ; generate_img
options="--img-4gb bone-\${base_rootfs}                 ${beaglebone} ${pru_rproc_v414ti}"                ; generate_img
options="--img-4gb bone-eMMC-flasher-\${base_rootfs}    ${beaglebone} ${pru_rproc_v414ti} --emmc-flasher" ; generate_img

options="--img-4gb BBBL-blank-\${base_rootfs}           ${beaglebone} ${pru_rproc_v414ti} --bbbl-flasher" ; generate_img

###DEBIAN STRETCH: lxqt-2gb
base_rootfs="${debian_stretch_lxqt_2gb}" ; blend="stretch-lxqt-2gb" ; extract_base_rootfs

options="--img-2gb bone-\${base_rootfs}               ${beaglebone} ${pru_rproc_v414ti}"                ; generate_img
options="--img-2gb bone-eMMC-flasher-\${base_rootfs}  ${beaglebone} ${pru_rproc_v414ti} --emmc-flasher" ; generate_img

###DEBIAN STRETCH: lxqt
base_rootfs="${debian_stretch_lxqt}" ; blend="stretch-lxqt" ; extract_base_rootfs

options="--img-4gb am57xx-\${base_rootfs}               ${beagle_x15}"                                    ; generate_img
options="--img-4gb bone-\${base_rootfs}                 ${beaglebone} ${pru_rproc_v414ti}"                ; generate_img
options="--img-4gb bone-eMMC-flasher-\${base_rootfs}    ${beaglebone} ${pru_rproc_v414ti} --emmc-flasher" ; generate_img

options="--img-4gb BBBW-blank-\${base_rootfs}           ${beaglebone} ${pru_rproc_v414ti} --bbbw-flasher" ; generate_img

###DEBIAN STRETCH: lxqt-tidl
base_rootfs="${debian_stretch_lxqt_tidl}" ; blend="stretch-lxqt-tidl" ; extract_base_rootfs

options="--img-6gb am57xx-\${base_rootfs}               ${beagle_x15}"                                    ; generate_img
options="--img-6gb am57xx-eMMC-flasher-\${base_rootfs}  ${beagle_x15} --emmc-flasher"                     ; generate_img
options="--img-6gb am57xx-blank-\${base_rootfs} ${beagle_x15} --emmc-flasher --am57xx-x15-revc-flasher" ; generate_img

###DEBIAN STRETCH: lxqt-xm
base_rootfs="${debian_stretch_lxqt_xm}" ; blend="stretch-lxqt-xm" ; extract_base_rootfs

options="--img-4gb bbxm-\${base_rootfs}  ${beagle_xm}" ; generate_img

###DEBIAN STRETCH: wayland
base_rootfs="${debian_stretch_wayland}" ; blend="stretch-wayland" ; extract_base_rootfs

options="--img-4gb am57xx-\${base_rootfs}  ${beagle_x15}" ; generate_img
options="--img-4gb bone-\${base_rootfs}    ${beaglebone}" ; generate_img

###DEBIAN BUSTER: console
base_rootfs="${debian_buster_console}" ; blend="buster-console" ; extract_base_rootfs

options="--img-1gb am57xx-\${base_rootfs}               ${beagle_x15}"                                    ; generate_img
options="--img-1gb am57xx-eMMC-flasher-\${base_rootfs}  ${beagle_x15} --emmc-flasher"                     ; generate_img
options="--img-1gb bone-\${base_rootfs}                 ${beaglebone} ${pru_rproc_v419ti}"                ; generate_img
options="--img-1gb bone-eMMC-flasher-\${base_rootfs}    ${beaglebone} ${pru_rproc_v419ti} --emmc-flasher" ; generate_img

###DEBIAN BUSTER: console-xm
base_rootfs="${debian_buster_console_xm}" ; blend="buster-console-xm" ; extract_base_rootfs

options="--img-1gb bbxm-\${base_rootfs}  ${beagle_xm}" ; generate_img

###DEBIAN BUSTER: iot
base_rootfs="${debian_buster_iot}" ; blend="buster-iot" ; extract_base_rootfs

options="--img-4gb am57xx-\${base_rootfs}               ${beagle_x15}"                                    ; generate_img
options="--img-4gb am57xx-eMMC-flasher-\${base_rootfs}  ${beagle_x15} --emmc-flasher"                     ; generate_img
options="--img-4gb bone-\${base_rootfs}                 ${beaglebone} ${pru_rproc_v419ti}"                ; generate_img
options="--img-4gb bone-eMMC-flasher-\${base_rootfs}    ${beaglebone} ${pru_rproc_v419ti} --emmc-flasher" ; generate_img

options="--img-4gb BBBL-blank-\${base_rootfs}           ${beaglebone} ${pru_rproc_v419ti} --bbbl-flasher" ; generate_img

###DEBIAN BUSTER: gobot-iot
base_rootfs="${debian_buster_gobot_iot}" ; blend="buster-gobot-iot" ; extract_base_rootfs

options="--img-4gb am57xx-\${base_rootfs}  ${beagle_x15}"                     ; generate_img
options="--img-4gb bone-\${base_rootfs}    ${beaglebone} ${pru_rproc_v419ti}" ; generate_img

###DEBIAN BUSTER: efi-iot
base_rootfs="${debian_buster_efi_iot}" ; blend="buster-efi-iot" ; extract_base_rootfs

options="--img-4gb am57xx-\${base_rootfs}  ${beagle_x15} --efi"                     ; generate_img
options="--img-4gb bone-\${base_rootfs}    ${beaglebone} ${pru_rproc_v419ti} --efi" ; generate_img

###DEBIAN BUSTER: lxqt
base_rootfs="${debian_buster_lxqt}" ; blend="buster-lxqt" ; extract_base_rootfs

options="--img-4gb am57xx-\${base_rootfs}  ${beagle_x15}"                     ; generate_img
options="--img-4gb bone-\${base_rootfs}    ${beaglebone} ${pru_rproc_v419ti}" ; generate_img

###UBUNTU BIONIC: ros-iot
base_rootfs="${ubuntu_bionic_ros_iot}" ; blend="bionic-ros-iot" ; extract_base_rootfs

options="--img-6gb am57xx-\${base_rootfs}  ${beagle_x15}"                      ; generate_img
options="--img-6gb bone-\${base_rootfs}    ${beaglebone} ${pru_rproc_v419ti}"  ; generate_img

###archive *.tar
base_rootfs="${debian_jessie_console}"        ; blend="console"         ; archive_base_rootfs
base_rootfs="${debian_jessie_lxqt_2gb}"       ; blend="lxqt-2gb"        ; archive_base_rootfs
base_rootfs="${debian_jessie_lxqt_4gb}"       ; blend="lxqt-4gb"        ; archive_base_rootfs
base_rootfs="${debian_jessie_lxqt_xm_4gb}"    ; blend="lxqt-xm-4gb"     ; archive_base_rootfs
base_rootfs="${debian_jessie_oemflasher}"     ; blend="oemflasher"      ; archive_base_rootfs
base_rootfs="${debian_jessie_seeed_iot}"      ; blend="seeed-iot"       ; archive_base_rootfs
base_rootfs="${debian_jessie_seeed_lxqt_4gb}" ; blend="seeed-lxqt-4gb"  ; archive_base_rootfs

base_rootfs="${debian_stretch_machinekit}"    ; blend="stretch-machinekit" ; archive_base_rootfs
base_rootfs="${debian_stretch_console}"       ; blend="stretch-console"    ; archive_base_rootfs
base_rootfs="${debian_stretch_iot}"           ; blend="stretch-iot"        ; archive_base_rootfs
base_rootfs="${debian_stretch_lxqt_2gb}"      ; blend="stretch-lxqt-2gb"   ; archive_base_rootfs
base_rootfs="${debian_stretch_lxqt}"          ; blend="stretch-lxqt"       ; archive_base_rootfs
base_rootfs="${debian_stretch_lxqt_tidl}"     ; blend="stretch-lxqt-tidl"  ; archive_base_rootfs
base_rootfs="${debian_stretch_lxqt_xm}"       ; blend="stretch-lxqt-xm"    ; archive_base_rootfs
base_rootfs="${debian_stretch_wayland}"       ; blend="stretch-wayland"    ; archive_base_rootfs
base_rootfs="${debian_stretch_oemflasher}"    ; blend="stretch-oemflasher" ; archive_base_rootfs

base_rootfs="${debian_buster_tiny}"           ; blend="buster-tiny"       ; archive_base_rootfs
base_rootfs="${debian_buster_console}"        ; blend="buster-console"    ; archive_base_rootfs
base_rootfs="${debian_buster_console_xm}"     ; blend="buster-console-xm" ; archive_base_rootfs
base_rootfs="${debian_buster_iot}"            ; blend="buster-iot"        ; archive_base_rootfs
base_rootfs="${debian_buster_gobot_iot}"      ; blend="buster-gobot-iot"  ; archive_base_rootfs
base_rootfs="${debian_buster_efi_iot}"        ; blend="buster-efi-iot"    ; archive_base_rootfs
base_rootfs="${debian_buster_lxqt}"           ; blend="buster-lxqt"       ; archive_base_rootfs

base_rootfs="${ubuntu_bionic_ros_iot}"        ; blend="bionic-ros-iot"  ; archive_base_rootfs

###archive *.img
###DEBIAN JESSIE: console
base_rootfs="${debian_jessie_console}" ; blend="console"

wfile="am57xx-\${base_rootfs}-1gb"               ; archive_img
wfile="am57xx-eMMC-flasher-\${base_rootfs}-1gb"  ; archive_img
wfile="bone-\${base_rootfs}-1gb"                 ; archive_img
wfile="bone-eMMC-flasher-\${base_rootfs}-1gb"    ; archive_img

###DEBIAN JESSIE: lxqt-2gb
base_rootfs="${debian_jessie_lxqt_2gb}" ; blend="lxqt-2gb"

wfile="bone-\${base_rootfs}-2gb"               ; archive_img
wfile="bone-eMMC-flasher-\${base_rootfs}-2gb"  ; archive_img

###DEBIAN JESSIE: lxqt-4gb
base_rootfs="${debian_jessie_lxqt_4gb}" ; blend="lxqt-4gb"

wfile="am57xx-\${base_rootfs}-4gb"               ; archive_img
wfile="am57xx-eMMC-flasher-\${base_rootfs}-4gb"  ; archive_img
wfile="bone-\${base_rootfs}-4gb"                 ; archive_img
wfile="bone-eMMC-flasher-\${base_rootfs}-4gb"    ; archive_img

###DEBIAN JESSIE: lxqt-xm
base_rootfs="${debian_jessie_lxqt_xm_4gb}" ; blend="lxqt-xm-4gb"

wfile="bbxm-\${base_rootfs}-4gb"  ; archive_img

###DEBIAN JESSIE: Seeed iot
base_rootfs="${debian_jessie_seeed_iot}" ; blend="seeed-iot"

wfile="bone-\${base_rootfs}-4gb"  ; archive_img

###DEBIAN JESSIE: Seeed lxqt-4gb
base_rootfs="${debian_jessie_seeed_lxqt_4gb}" ; blend="seeed-lxqt-4gb"

wfile="bone-\${base_rootfs}-4gb"  ; archive_img

###DEBIAN STRETCH: machinekit
base_rootfs="${debian_stretch_machinekit}" ; blend="stretch-machinekit"

wfile="bone-\${base_rootfs}-4gb"  ; archive_img

###DEBIAN STRETCH: console
base_rootfs="${debian_stretch_console}" ; blend="stretch-console"

wfile="am57xx-\${base_rootfs}-1gb"               ; archive_img
wfile="am57xx-eMMC-flasher-\${base_rootfs}-1gb"  ; archive_img
wfile="bone-\${base_rootfs}-1gb"                 ; archive_img
wfile="bone-eMMC-flasher-\${base_rootfs}-1gb"    ; archive_img

###DEBIAN STRETCH: iot
base_rootfs="${debian_stretch_iot}" ; blend="stretch-iot"

wfile="am57xx-\${base_rootfs}-4gb"               ; archive_img
wfile="am57xx-eMMC-flasher-\${base_rootfs}-4gb"  ; archive_img
wfile="bone-\${base_rootfs}-4gb"                 ; archive_img
wfile="bone-eMMC-flasher-\${base_rootfs}-4gb"    ; archive_img

wfile="BBBL-blank-\${base_rootfs}-4gb"         ; archive_img

###DEBIAN STRETCH: lxqt-2gb
base_rootfs="${debian_stretch_lxqt_2gb}" ; blend="stretch-lxqt-2gb"

wfile="bone-\${base_rootfs}-2gb"               ; archive_img
wfile="bone-eMMC-flasher-\${base_rootfs}-2gb"  ; archive_img

###DEBIAN STRETCH: lxqt
base_rootfs="${debian_stretch_lxqt}" ; blend="stretch-lxqt"

wfile="am57xx-\${base_rootfs}-4gb"               ; archive_img
wfile="bone-\${base_rootfs}-4gb"                 ; archive_img
wfile="bone-eMMC-flasher-\${base_rootfs}-4gb"    ; archive_img

wfile="BBBW-blank-\${base_rootfs}-4gb"         ; archive_img

###DEBIAN STRETCH: lxqt-tidl
base_rootfs="${debian_stretch_lxqt_tidl}" ; blend="stretch-lxqt-tidl"

wfile="am57xx-\${base_rootfs}-6gb"               ; archive_img
wfile="am57xx-eMMC-flasher-\${base_rootfs}-6gb"  ; archive_img

wfile="am57xx-blank-\${base_rootfs}-6gb"       ; archive_img

###DEBIAN STRETCH: lxqt-xm
base_rootfs="${debian_stretch_lxqt_xm}" ; blend="stretch-lxqt-xm"

wfile="bbxm-\${base_rootfs}-4gb"  ; archive_img

###DEBIAN STRETCH: wayland
base_rootfs="${debian_stretch_wayland}" ; blend="stretch-wayland"

wfile="am57xx-\${base_rootfs}-4gb"  ; archive_img
wfile="bone-\${base_rootfs}-4gb"    ; archive_img

###DEBIAN BUSTER: console
base_rootfs="${debian_buster_console}" ; blend="buster-console"

wfile="am57xx-\${base_rootfs}-1gb"               ; archive_img
wfile="am57xx-eMMC-flasher-\${base_rootfs}-1gb"  ; archive_img
wfile="bone-\${base_rootfs}-1gb"                 ; archive_img
wfile="bone-eMMC-flasher-\${base_rootfs}-1gb"    ; archive_img

###DEBIAN BUSTER: console-xm
base_rootfs="${debian_buster_console_xm}" ; blend="buster-console-xm"

wfile="bbxm-\${base_rootfs}-1gb"               ; archive_img

###DEBIAN BUSTER: iot
base_rootfs="${debian_buster_iot}" ; blend="buster-iot"

wfile="am57xx-\${base_rootfs}-4gb"               ; archive_img
wfile="am57xx-eMMC-flasher-\${base_rootfs}-4gb"  ; archive_img
wfile="bone-\${base_rootfs}-4gb"                 ; archive_img
wfile="bone-eMMC-flasher-\${base_rootfs}-4gb"    ; archive_img

wfile="BBBL-blank-\${base_rootfs}-4gb"         ; archive_img

###DEBIAN BUSTER: gobot-iot
base_rootfs="${debian_buster_gobot_iot}" ; blend="buster-gobot-iot"

wfile="am57xx-\${base_rootfs}-4gb"  ; archive_img
wfile="bone-\${base_rootfs}-4gb"    ; archive_img

###DEBIAN BUSTER: efi-iot
base_rootfs="${debian_buster_efi_iot}" ; blend="buster-efi-iot"

wfile="am57xx-\${base_rootfs}-4gb"  ; archive_img
wfile="bone-\${base_rootfs}-4gb"    ; archive_img

###DEBIAN BUSTER: lxqt
base_rootfs="${debian_buster_lxqt}" ; blend="buster-lxqt"

wfile="am57xx-\${base_rootfs}-4gb"  ; archive_img
wfile="bone-\${base_rootfs}-4gb"    ; archive_img

###UBUNTU BIONIC: ros-iot
base_rootfs="${ubuntu_bionic_ros_iot}" ; blend="bionic-ros-iot"

wfile="am57xx-\${base_rootfs}-6gb"  ; archive_img
wfile="bone-\${base_rootfs}-6gb"    ; archive_img

__EOF__

chmod +x ${DIR}/deploy/gift_wrap_final_images.sh

image_prefix="bb.org"
#node:
if [ ! -d /var/www/html/farm/images/ ] ; then
	if [ ! -d /mnt/farm/images/ ] ; then
		#nfs mount...
		sudo mount -a
	fi

	if [ -d /mnt/farm/images/ ] ; then
		mkdir -p /mnt/farm/images/${image_prefix}-${time}/ || true
		echo "Copying: *.tar to server: images/${image_prefix}-${time}/"
		cp -v ${DIR}/deploy/*.tar /mnt/farm/images/${image_prefix}-${time}/ || true
		cp -v ${DIR}/deploy/gift_wrap_final_images.sh /mnt/farm/images/${image_prefix}-${time}/gift_wrap_final_images.sh || true
		chmod +x /mnt/farm/images/${image_prefix}-${time}/gift_wrap_final_images.sh || true
	fi
fi

#x86:
if [ -d /var/www/html/farm/images/ ] ; then
	mkdir -p /var/www/html/farm/images/${image_prefix}-${time}/ || true
	echo "Copying: *.tar to server: images/${image_prefix}-${time}/"
	cp -v ${DIR}/deploy/gift_wrap_final_images.sh /var/www/html/farm/images/${image_prefix}-${time}/gift_wrap_final_images.sh || true
	chmod +x /var/www/html/farm/images/${image_prefix}-${time}/gift_wrap_final_images.sh || true
	sudo chown -R apt-cacher-ng:apt-cacher-ng /var/www/html/farm/images/${image_prefix}-${time}/ || true
fi
