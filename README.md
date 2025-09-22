# AdaOS KDE Plasma Installer

![Built for AdaOS](https://img.shields.io/badge/Built%20for-AdaOS-blue?style=for-the-badge)

This is a simple Bash script to install the **KDE Plasma Desktop** on Debian-based systems, branded for **AdaOS**.  
It supports minimal, standard, and full KDE profiles, and lets you choose which display manager to install.

---

## ✨ Features

- Install **KDE Plasma** (`minimal`, `standard`, or `full` package sets).  
- Interactive **Display Manager selection** (`sddm`, `lightdm`, `gdm3`, or none).  
- Optionally installs:
  - KDE utilities (Dolphin, Konsole, Kate, Ark, Plasma Disks)  
  - Multimedia codecs (VLC, FFmpeg, libavcodec-extra)  
  - Printer support (CUPS, drivers)  
  - Flatpak support  
- AdaOS branded output + log file at `/var/log/adaos-kde-installer.log`.  
- Cleans up packages after install.  
- Can automatically reboot when finished.  

---

## 🔧 Usage

### 1. Clone or download
```bash
git clone https://github.com/YOUR-USERNAME/adaos-kde-installer.git
cd adaos-kde-installer
```

### 2. Make the script executable
```bash
chmod +x adaos-kdeinstaller.sh
```

### 3. Run it with **bash** (not sh)
```bash
sudo ./adaos-kdeinstaller.sh
```

⚠️ Don’t run with `sh` — it will fail. Always use `bash` or `./`.

---

## 📦 Options

You can pass options to customize the installation:

| Option           | Description |
|------------------|-------------|
| `--profile minimal`  | Minimal KDE Plasma (desktop shell only) |
| `--profile standard` | Standard KDE Plasma (recommended, default) |
| `--profile full`     | Full KDE Plasma (all KDE apps) |
| `--no-extras`        | Skip extras (codecs, printers, Flatpak, utilities) |
| `--reboot`           | Automatically reboot after install |

Example:

```bash
sudo ./adaos-kdeinstaller.sh --profile standard --reboot
```

---

## 🖥️ Display Manager Selection

During installation, you’ll be asked which **Display Manager** (login screen) you want:

- **sddm** (default, KDE’s official DM)  
- **lightdm**  
- **gdm3**  
- **none** (skip, configure manually later)  

---

## 📄 Logs

All actions are logged to:

```
/var/log/adaos-kde-installer.log
```

---

## 🚀 After Installation

- Reboot your system:  
  ```bash
  sudo reboot
  ```
- Log in to **KDE Plasma** using your chosen display manager.  
- Customize Plasma via **System Settings**.  

---

## ⚠️ Notes

- Tested on **Debian 11 (Bullseye)**, **Debian 12 (Bookworm)**, and newer.  
- Requires `bash`, `sudo`, and internet access.  
- For NVIDIA GPUs, enable **non-free repositories** and install `nvidia-driver` if desired.  

---

## 📜 License

MIT License.  
Feel free to adapt this script for your own distro, but credit AdaOS if you reuse the branding.

---
