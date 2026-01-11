#!/bin/bash

set -euo pipefail

echo "This Script is used to install this dot from a CLEAN INSTALLATION of ARCH LINUX."
echo "If you have set up Niri/sddm/other DE already, you can simply use the other Script replace.sh."
echo "Note that this Script is more about convience so it might break your own configuration."
echo "Do you wish to continue?[y/N]"

while true; do
  read -r yn2 || yn2=""
  yn2=${yn2:-n}
  case "$yn2" in
  [Yy])
    echo "Lets GO!"
    break
    ;;
  [Nn])
    echo "Aborting.."
    exit 0
    ;;
  *)
    echo "Input y/n (default=n)"
    ;;
  esac
done

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "This Script contains installation, which needs your sudo permission:"
sudo -v

# Print key-value nicely: key: value
kv() {
  local k="$1"
  shift
  local v="${1:-}"
  printf "%-14s %s\n" "${k}:" "${v}"
}

# Defaults
ID=""
ID_LIKE=""
NAME=""
PRETTY_NAME=""
VERSION_ID=""
VERSION_CODENAME=""

# 1) Best source: /etc/os-release
if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  ID="${ID:-}"
  ID_LIKE="${ID_LIKE:-}"
  NAME="${NAME:-}"
  PRETTY_NAME="${PRETTY_NAME:-}"
  VERSION_ID="${VERSION_ID:-}"
  VERSION_CODENAME="${VERSION_CODENAME:-}"

# 2) Fallback: lsb_release
elif command -v lsb_release >/dev/null 2>&1; then
  NAME="$(lsb_release -si 2>/dev/null || true)"
  VERSION_ID="$(lsb_release -sr 2>/dev/null || true)"
  VERSION_CODENAME="$(lsb_release -sc 2>/dev/null || true)"
  PRETTY_NAME="${NAME} ${VERSION_ID}"

# 3) Fallback: hostnamectl (systemd)
elif command -v hostnamectl >/dev/null 2>&1; then
  # Example line: "Operating System: Arch Linux"
  PRETTY_NAME="$(hostnamectl 2>/dev/null | awk -F': ' '/Operating System/ {print $2; exit}' || true)"

# 4) Last resort: /etc/issue
elif [[ -r /etc/issue ]]; then
  PRETTY_NAME="$(head -n1 /etc/issue | sed 's/\\.*$//' | xargs || true)"
fi

# Normalize: if PRETTY_NAME empty, try to build
if [[ -z "${PRETTY_NAME}" ]]; then
  PRETTY_NAME="${NAME:-Unknown Linux}${VERSION_ID:+ ${VERSION_ID}}"
fi

echo "== Distro info =="
kv "PRETTY_NAME" "${PRETTY_NAME}"
kv "ID" "${ID}"
kv "ID_LIKE" "${ID_LIKE}"
kv "NAME" "${NAME}"
kv "VERSION_ID" "${VERSION_ID}"
kv "CODENAME" "${VERSION_CODENAME}"

# Optional: classify into a "family"
family="unknown"
case "${ID:-}" in
arch | manjaro | endeavouros) family="arch" ;;
ubuntu | debian | linuxmint | pop | elementary | kali) family="debian" ;;
fedora | rhel | centos | rocky | alma | ol) family="rhel" ;;
opensuse* | sles) family="suse" ;;
alpine) family="alpine" ;;
esac
kv "FAMILY" "${family}"

if [ "$family" = "arch" ]; then
  echo "This dot recommends you to install the following packages:"
  echo "cava fastfetch fuzzel kitty mako niri swaylock-fancy-git swaync waybar wlogout wofi sddm"
  echo "Do you wish to install these needed packages? [Y/n]"
  while true; do
    read -r yn || yn=""
    yn=${yn:-y} # 回车默认 y
    case "$yn" in
    [Yy])
      echo "OK, installing..."

      aur_helper=""
      if command -v yay >/dev/null 2>&1; then
        aur_helper="yay"
      elif command -v paru >/dev/null 2>&1; then
        aur_helper="paru"
      fi

      if [[ -n "$aur_helper" ]]; then
        echo "Found AUR helper: $aur_helper"
      else
        echo "No AUR helper found (yay/paru). Do you wish to install yay/paru?[y(yay)/p(paru)/n(don't install)]"
        while true; do
          read -r yn1 || yn1=""
          case "$yn1" in
          [Yy])
            echo "Installing Yay for you..."
            sudo pacman -S --needed git base-devel
            tmpdir="$(mktemp -d)"
            (
              trap 'rm -rf "$tmpdir"' EXIT
              cd "$tmpdir"
              git clone https://aur.archlinux.org/yay-bin.git
              cd yay-bin
              makepkg -si --noconfirm
            )
            command -v yay >/dev/null 2>&1 && aur_helper="yay" || aur_helper=""
            break
            ;;
          [Pp])
            echo "Installing Paru for you..."
            sudo pacman -S --needed git base-devel
            tmpdir="$(mktemp -d)"
            (
              trap 'rm -rf "$tmpdir"' EXIT
              cd "$tmpdir"
              git clone https://aur.archlinux.org/paru.git
              cd paru
              makepkg -si --noconfirm
            )
            command -v paru >/dev/null 2>&1 && aur_helper="paru" || aur_helper=""
            break
            ;;
          [Nn])
            echo "Skipped."
            break
            ;;
          *)
            echo "Please enter y/p/n."
            ;;
          esac
        done
      fi

      if [[ -z "$aur_helper" ]]; then
        echo "Continue installing using pacman, replacing swaylock-fancy with swaylock"
        sudo pacman -S --needed cava fastfetch fuzzel kitty mako niri swaylock swaync waybar wlogout wofi swaybg swww sddm
      else
        echo "Installing packages..."
        "$aur_helper" -S --needed cava fastfetch fuzzel kitty mako niri swaylock-fancy-git swaync waybar wlogout wofi swaybg swww sddm
      fi

      echo "Setting up SDDM..."
      sudo systemctl enable --now sddm.service
      sudo systemctl set-default graphical.target
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)" || echo "SDDM theme setup failed, skipped."

      mkdir -p ~/.config
      shopt -s nullglob dotglob
      cp -r "$script_dir/.configs/"* ~/.config/
      shopt -u nullglob dotglob

      echo "Do you wish to use the grub theme from https://github.com/mateosss/matter?[Y/n]"
      while true; do
        read -r yn3 || yn3=""
        yn3=${yn3:-y}
        case "$yn3" in
        [Yy])
          echo "Setting up grub theme..."
          python3 "$script_dir/matter/matter.py"
          echo "./matter/matter.py -i(write your params here):"
          read -r -a tokens || tokens=()
          python3 "$script_dir/matter/matter.py" -i "${tokens[@]}"
          break
          ;;
        [Nn])
          echo "Skipped."
          break
          ;;
        *)
          echo "Please Input y/n (default=y)"
          ;;
        esac
      done
      break
      ;;
    [Nn])
      echo "Skipped."
      break
      ;;
    *) echo "Please enter y or n (default: y): " ;;
    esac
  done
else
  echo "Your Distro is not supported yet, Please install these needed packages manually:"
  echo "cava fastfetch fuzzel kitty mako niri swaylock swaync swww swagbg waybar wlogout wofi sddm"
  echo "You can use the replace.sh to replace all the configs after install. :)"
fi
