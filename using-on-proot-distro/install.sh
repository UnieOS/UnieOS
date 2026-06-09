#!/data/data/com.termux/files/usr/bin/bash

UNIEOS_DIR="/data/data/com.termux/files/usr/var/lib/proot-distro/containers/unieos/rootfs"

pkg update
pkg upgrade
pkg install proot
pkg install python3
pkg install git
pkg install clang

pip install proot-distro

proot-distro install debian:13 --name unieos
echo "We will create a user in the sandbox environment. Enter a name."
read -p "Name: " userName
proot-distro login unieos -- useradd ${userName}
proot-distro login unieos -- usermod -aG ${userName}
proot-distro login unieos -- apt update 
proot-distro login unieos -- apt upgrade

mkdir -p "$TMPDIR/UnieOS"
export UNIETMP="$TMPDIR/UnieOS"

git clone https://github.com/UnieOS/UnieOS ${UNIETMP}/repo
export REPO="$UNIETMP/repo"

rm -f ${UNIEOS_DIR}/etc/os-release
cp ${REPO}/etc/os-release ${UNIEOS_DIR}/etc/os-release

mkdir -p ${UNIETMP}/ucomp
UCOMP="$UNIETMP/ucomp
cp ${REPO}/usr.bin/panic.cpp ${UCOMP}/panic.cpp
cp ${REPO}/usr.bin/utop.c ${UCOMP}/utop.c

clang++ ${UCOMP}/panic.cpp -o ${UNIEOS_DIR}/usr/bin/panic
clang ${UCOMP}/utop.c -o ${UNIEOS_DIR}/usr/bin/utop
echo "Installed! Login with"
echo "proot-distro login unieos"
