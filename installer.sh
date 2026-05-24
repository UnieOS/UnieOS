#!/bin/bash
DIR="/mnt/unie-os-x86"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
RESET="\033[0m"

echo "UnieOS installer for x86 and x86_64 architectures, and for Debian GNU/Linux"
echo "https://github.com/UnieOS/"
echo "https://unieos.github.io/"
arch="$(uname -m)"

case "$arch" in
  x86_64|i386|i686)
    ;;
  *)
    echo -e "${RED}[E]${RESET}: Architecture not x86!"
    exit 1
    ;;
esac

if [ -f /etc/os-release ]; then
  . /etc/os-release
  echo "$ID $ID_LIKE" | grep -qi debian || {
    echo -e "${RED}[E]${RESET}: Not Debian or Debian-based distro."
    exit 1
  }
else
  echo -e  "${RED}[E]${RESET}: This environment is not a Linux distribution! Exiting"
  exit 1
fi
sudo mkdir -p "$DIR"
sudo mkdir -p "$DIR/usr"
sudo mkdir -p "$DIR/usr/local"
sudo mkdir -p "$DIR/usr/local/ucomp"
sudo mkdir -p "$DIR/usr/bin"
UCOMPDIR="$DIR/usr/local/ucomp"
command -v "git" >/dev/null && echo -e "${BLUE}[I]${RESET}: git is installed. Continue" || sudo apt install -y git
command -v "curl" >/dev/null && echo -e  "${BLUE}[I]${RESET}: curl is installed. Continue" || sudo apt install -y curl
command -v "make" >/dev/null && echo -e "${BLUE}[I]${RESET}: make is installed. Continue" || sudo apt install -y make
sudo curl -L https://raw.githubusercontent.com/UnieOS/UnieOS/refs/heads/unie-0.1.0/usr.bin/utop.c -o "$DIR/usr/local/ucomp/utop.c"
sudo clang "$UCOMPDIR/utop.c" -v -o "$DIR/usr/bin/utop"
exit 0 # Script on development. Wait
