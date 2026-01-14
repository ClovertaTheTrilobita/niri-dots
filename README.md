# My Niri Dots

> Though I'm not yet sure if this can be called a dotfile since it's so simple.

<img width="2560" height="1440" alt="image" src="https://github.com/user-attachments/assets/a16690d6-b45d-454c-87b4-a828e7cf02ca" />

<img width="2560" height="1440" alt="image" src="https://github.com/user-attachments/assets/a342de25-90ca-487d-a854-2e0b8b2b3f3d" />

<img width="2560" height="1440" alt="image" src="https://github.com/user-attachments/assets/4971cc93-436f-4d41-b757-a542c4b07486" />

Every time when I re-install my PC, I always feels like to try some new dotfiles. But as I searched through Internet the dotfiles I found were whether not stable or deeply customized and hard to make changes.

So I began the long and time-costing Niri customization.

I want it to be simple, reliable, easy and good-looking. As I'm not expert in designing and I'm super confident about doing bad in color design, the components I use are mainly simple modifications based on other peoples work (which are listed below).

This dot is really simple, and especially easy to make adjustments if you like. It provides an out-of-the box interface so you don't need to spend the whole afternoon adjusting corner radius and fighting against the hard-to-remember CSS code.

Okay so lets talk about how to use.

## Installation

### Clean Install

The installation script currently only supports Arch Linux if you are starting from a clean system installation environment.

> [!IMPORTANT]
>
> Please pull the submodule together with the `--recurse-submodules` fl

```shell
git clone --recurse-submodules https://github.com/ClovertaTheTrilobita/niri-dots.git
chmod +x install.sh
./install.sh
```

> [!WARNING]
>
> This script should only be used when you just setup your system and haven't install anything yet. It might (though the possibilities are low) break some of your packages since it'll do packages installations for you.

After rebooting your system in to Niri, if you want to switch wallpaper, simply execute

```shell
chmod +x $HOME/.config/niri/scripts/switch-wallpaper.sh
$HOME/.config/niri/scripts/switch-wallpaper.sh <path/to/your/walpaper.png>
```

Note that this script doesn't install packages that might deeply effect your system e.g. `powerprofilesctl`, you have the freedom to configure it your self :p

### If you already done some configuration

That's even more simple!

```shell
chmod +x replace.sh
./replace.sh
```

This will replace some of your config files (It will make backups).

> [!NOTE]
>
> This script doesn't do any installations, so you need to install all packages by your self.

### Manual installation

I guess this dot might be a bit too easy to use an installation script.

#### Arch Linux

##### 1. Install packages

```shell
yay -S --needed ttf-iosevka-nerd ttf-hack cava imagemagick cliphist fastfetch fuzzel kitty mako niri swaylock-fancy-git swaync waybar wlogout wofi swaybg swww sddm cliphist
```

##### 2. Copy configuration files

copy all folders in `.config` to your own `XDG_CONFIG_HOME` (mostly `~/.config`)

##### 3. Setup grub theme

if you want to use the grub theme

```shell
cd matter
./matter.py
```

##### 4.SDDM theme

I recommend using this sddm theme [Keyitdev/sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme). You can install it with simply

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
```

<br>

## ⚖️ Code and Licenses

This repo contains code and inspiration from:

- **[catppuccin/waybar](https://github.com/catppuccin/waybar)**, **[jvc84/wayves](https://github.com/jvc84/wayves)**, **[DerAnsari/hyprland-dots](https://github.com/DerAnsari/hyprland-dots/tree/main/waybar/)** for `waybar`.
- **[catppuccin/wlogout](https://github.com/catppuccin/wlogout)**, **[wolf-yuan/dotfiles](https://gitlab.com/wolf-yuan/dotfiles/-/blob/main/.config/wlogout/style.css?ref_type=heads)** for `wlogout`
- **[LierB/fastfetch](https://github.com/LierB/fastfetch)** for `fastfetch`
- **[catppuccin/fuzzel](https://github.com/catppuccin/fuzzel)** for `fuzzel`
- **[mateosss/matter](https://github.com/mateosss/matter)** for `grub`

This repo is licensed under `MIT LICENSE`, you can use it whatever you like =)