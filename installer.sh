#!/bin/bash
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

command -v "git" >/dev/null && echo -e "${BLUE}[I]${RESET}: git is installed. Continue" || sudo apt install git
command -v "curl" >/dev/null && echo -e  "${BLUE}[I]${RESET}: curl is installed. Continue" || sudo apt install curl
command -v "make" >/dev/null && echo -e "${BLUE}[I]${RESET}: make is installed. Continue" || sudo apt install make
exit 0 # Script on development. Wait
