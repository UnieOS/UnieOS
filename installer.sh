#!/bin/bash

RED="\e[31m"
RESET="\e[0m"

arch=$(uname -m)

case "$arch" in
  x86_64|i386|i686)
    ;;
  *)
    echo -e "${RED}[E]${RESET}: Architecture not x86!"
    exit 1
    ;;
esac

if [ -f /etc/os-release ]; then
  if ! grep -qiE 'debian' /etc/os-release; then
    echo -e "${RED}[E]${RESET}: Not Debian or Debian-based distro."
    exit 1
  fi
else
  echo -e "${RED}[E]${RESET}: This environment is not a Linux distribution! Exiting"
  exit 1
fi

DIR_x86=/mnt/unieos

command -v sudo >/dev/null 2>&1 || {
  echo "sudo is not installed. Please install sudo!"
  exit 1
}

command -v debootstrap >/dev/null 2>&1 || sudo apt install -y debootstrap
command -v clang >/dev/null 2>&1 || sudo apt install -y clang
command -v git >/dev/null 2>&1 || sudo apt install -y git
command -v curl >/dev/null 2>&1 || sudo apt install -y curl libcurl4

mkdir -p "$DIR_x86"

sudo debootstrap trixie "$DIR_x86" http://deb.debian.org/debian
rm -f "$DIR_x86"/etc/os-release
curl -L "https://raw.githubusercontent.com/UnieOS/UnieOS/refs/heads/unie-0.1.0/etc/os-release"  -o "$DIR_x86"/etc/os-release
echo "This script is still on development."
exit 0
