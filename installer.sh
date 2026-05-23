#!/bin/dash

echo "UnieOS installer for x86 and x86_64 architectures, and for Debian GNU/Linux"
echo "https://github.com/UnieOS/"
echo "https://unieos.github.io/"
arch="$(uname -m)"

case "$arch" in
  x86_64|i386|i686)
    ;;
  *)
    echo "Architecture not x86!"
    exit 1
    ;;
esac

if [ -f /etc/os-release ]; then
  . /etc/os-release
  echo "$ID $ID_LIKE" | grep -qi debian || {
    echo "Not Debian or Debian-based distro."
    exit 1
  }
else
  echo "This environment is not a Linux distribution! Exiting"
  exit 1
fi

command -v "git" >/dev/null && echo "git is installed. Continue" || sudo apt install git
command -v "curl" >/dev/null && echo "curl is installed. Continue" || sudo apt install curl
command -v "make" >/dev/null && echo "make is installed. Continue" || sudo apt install make
exit 0 # Script on development. Wait
