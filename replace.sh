#!/bin/bash

set -euo pipefail

echo "This is a really simple script that helps you move all config files into place."
echo "So you don't need to replace them one by one."
echo "Make sure you have the following packages installed (if you want to use them):"
echo "cava cliphist imagemagick fastfetch fuzzel kitty mako niri swaylock swaync swww swaybg waybar wlogout wofi sddm"

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

echo "Setting up SDDM Theme..."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)" || echo "SDDM theme setup failed, skipped."

mkdir -p ~/.config
shopt -s nullglob dotglob

[ -d "$src" ] || {
  echo "ERROR: $src not found"
  exit 1
}
src="$script_dir/.configs"
dst="$HOME/.config"
ts="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$dst"

# 遍历 .configs 下的顶层内容（目录/文件）
for p in "$src"/*; do
  [ -e "$p" ] || continue
  name="$(basename "$p")"
  target="$dst/$name"

  if [ -d "$target" ]; then
    bak="${target}.bak-${ts}"
    # 极小概率同名（例如同一秒多次运行），就追加序号
    i=1
    while [ -e "$bak" ]; do
      bak="${target}.bak-${ts}-${i}"
      i=$((i + 1))
    done
    mv -- "$target" "$bak"
  elif [ -e "$target" ]; then
    bak="${target}.bak-${ts}"
    i=1
    while [ -e "$bak" ]; do
      bak="${target}.bak-${ts}-${i}"
      i=$((i + 1))
    done
    mv -- "$target" "$bak"
  fi

  # 再复制新的进去
  cp -a -- "$p" "$dst/"
done
shopt -u nullglob dotglob

chmod +x "$HOME/.config/niri/scripts/switch-wallpaper.sh"
if [ -x "$HOME/.config/niri/scripts/switch-wallpaper.sh" ] && [ -f "$HOME/.config/niri/wallpapers/sunset.jpg" ]; then
  "$HOME/.config/niri/scripts/switch-wallpaper.sh" "$HOME/.config/niri/wallpapers/sunset.jpg"
fi

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
