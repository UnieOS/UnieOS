#!/data/data/com.termux/files/usr/bin/bash

UNIEOS_DIR="/data/data/com.termux/files/usr/var/lib/proot-distro/containers/unieos/rootfs"

apt-get update -y
apt-get upgrade -y
apt-get install proot -y
apt-get install python3 -y
apt-get install git -y
apt-get install clang -y

pip install proot-distro

proot-distro install debian:13 --name unieos
echo "We will create a user in the sandbox environment. Enter a name."
read -p "Name: " userName
proot-distro login unieos -- useradd ${userName}
proot-distro login unieos -- usermod -aG sudo ${userName}
proot-distro login unieos -- apt update 
proot-distro login unieos -- apt upgrade
proot-distro login unieos -- apt install sudo

mkdir -p "$TMPDIR/UnieOS"
export UNIETMP="$TMPDIR/UnieOS"

git clone https://github.com/UnieOS/UnieOS ${UNIETMP}/repo
export REPO="$UNIETMP/repo"

rm -f ${UNIEOS_DIR}/etc/os-release
cp ${REPO}/etc/os-release ${UNIEOS_DIR}/etc/os-release

mkdir -p ${UNIETMP}/ucomp
UCOMP="$UNIETMP/ucomp"
cp ${REPO}/usr.bin/panic.cpp ${UCOMP}/panic.cpp
cp ${REPO}/usr.bin/utop.c ${UCOMP}/utop.c

proot-distro login unieos -- bash -c "apt-get install clang -y && \
clang++ ${UCOMP}/panic.cpp -o ${UNIEOS_DIR}/usr/bin/panic && \
clang ${UCOMP}/utop.c -o ${UNIEOS_DIR}/usr/bin/utop"
echo "Installed! Login with"
echo "proot-distro login unieos"
