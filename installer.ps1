# Even though this code is PowerShell, it's still written for Linux (Microsoft also maintains PowerShell for Linux).
# This code is written by LLMs, and due to the lack of computers at the moment, it cannot be tested. If there are any consequences, please don't report us, just let us know.

Import-Module "./installerModule.psm1" -Force

Assert-SudoPrivileges

$DIR = "/mnt/unie-os-x86"
$RED = "[node(31m]"
$GREEN = "[node(32m]"
$YELLOW = "[node(33m]"
$BLUE = "[node(34m]"
$MAGENTA = "[node(35m]"
$CYAN = "[node(36m]"
$WHITE = "[node(37m]"
$RESET = "[node(0m]"

Write-Host "UnieOS installer for x86 and x86_64 architectures, and for Debian GNU/Linux"
Write-Host "https://github.com/UnieOS/"
Write-Host "https://unieos.github.io/"

$arch = (uname -m).Trim()

switch -Regex ($arch) {
    "^(x86_64|i386|i686)$" { break }
    Default {
        Write-Host "${RED}[E]${RESET}: Architecture not x86!"
        exit 1
    }
}

if (Test-Path "/etc/os-release") {
    $osRelease = Get-Content "/etc/os-release" | ConvertFrom-StringData
    $id = $osRelease["ID"]
    $idLike = $osRelease["ID_LIKE"]
    
    if (-not ($id -match "debian" -or $idLike -match "debian")) {
        Write-Host "${RED}[E]${RESET}: Not Debian or Debian-based distro."
        exit 1
    }
} else {
    Write-Host "${RED}[E]${RESET}: This environment is not a Linux distribution! Exiting"
    exit 1
}

$null = mkdir -p "$DIR"
$null = mkdir -p "$DIR/usr"
$null = mkdir -p "$DIR/usr/local"
$null = mkdir -p "$DIR/usr/local/ucomp"
$null = mkdir -p "$DIR/usr/bin"
$UCOMPDIR = "$DIR/usr/local/ucomp"
$null = mkdir -p "$DIR/dev"
$null = mkdir -p "$DIR/sys"
$null = mkdir -p "$DIR/proc"
$null = mkdir -p "$DIR/usr/lib64"
$null = mkdir -p "$DIR/usr/lib"

Write-Host "${RED}[WARNING]${RESET} After using UnieOS, PLEASE REBOOT YOU COMPUTER FOR UNMOUNT BIND MOUNTS!"

mount --bind /dev "$DIR/dev"
mount --bind /sys "$DIR/sys"
mount --bind /proc "$DIR/proc"
mount --rbind /usr/lib64 "$DIR/usr/lib64"
mount --rbind /usr/lib "$DIR/usr/lib"

if (Get-Command "git" -ErrorAction SilentlyContinue) { Write-Host "${BLUE}[I]${RESET}: git is installed. Continue" } else { apt install -y git }
if (Get-Command "curl" -ErrorAction SilentlyContinue) { Write-Host "${BLUE}[I]${RESET}: curl is installed. Continue" } else { apt install -y curl }
if (Get-Command "make" -ErrorAction SilentlyContinue) { Write-Host "${BLUE}[I]${RESET}: make is installed. Continue" } else { apt install -y make }
if (Get-Command "clang" -ErrorAction SilentlyContinue) { Write-Host "${BLUE}[I]${RESET}: clang is installed. Continue" } else { apt install -y clang }

curl -L "https://raw.githubusercontent.com/UnieOS/UnieOS/refs/heads/unie-0.1.0/usr.bin/utop.c" -o "$DIR/usr/local/ucomp/utop.c"
clang "$UCOMPDIR/utop.c" -v -o "$DIR/usr/bin/utop"
Remove-Item -Force "$UCOMPDIR/utop.c" -ErrorAction SilentlyContinue

curl -L "https://raw.githubusercontent.com/UnieOS/UnieOS/refs/heads/unie-0.1.0/usr.bin/panic.cpp" -o "$UCOMPDIR/panic.cpp"
clang++ $UCOMPDIR/panic.cpp -o "$DIR/usr/bin/panic"
Remove-Item -Force "$UCOMPDIR/panic.cpp" -ErrorAction SilentlyContinue

exit 0
