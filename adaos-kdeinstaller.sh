#!/usr/bin/env bash
# AdaOS KDE Plasma Installer
# Usage: sudo ./adaos-kde-installer.sh [--profile minimal|standard|full] [--no-extras] [--reboot]
# Default profile: standard

set -euo pipefail
SCRIPT_NAME="$(basename "$0")"
LOGFILE="/var/log/adaos-kde-installer.log"

# Defaults
PROFILE="standard"
INSTALL_EXTRAS=true
AUTO_REBOOT=false
DEBIAN_FRONTEND_DEFAULT="${DEBIAN_FRONTEND:-interactive}"

info() { echo -e "[\e[36mAdaOS\e[0m] $*"; }
warn() { echo -e "[\e[33mAdaOS WARNING\e[0m] $*"; }
err()  { echo -e "[\e[31mAdaOS ERROR\e[0m] $*" >&2; }
die()  { err "$*"; exit 1; }

# parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) PROFILE="${2:-}"; shift 2 ;;
    --no-extras) INSTALL_EXTRAS=false; shift ;;
    --reboot) AUTO_REBOOT=true; shift ;;
    -h|--help)
      cat <<EOF
AdaOS KDE Plasma Installer
Usage: sudo $SCRIPT_NAME [--profile minimal|standard|full] [--no-extras] [--reboot]

Options:
  --profile   minimal | standard | full  (default: standard)
  --no-extras Skip codecs, flatpak, printer utils
  --reboot    Reboot automatically after install
EOF
      exit 0
      ;;
    *) warn "Unknown argument: $1"; shift ;;
  esac
done

# require root
if [[ $EUID -ne 0 ]]; then
  die "This script must be run as root. Try: sudo ./adaos-kde-installer.sh"
fi

mkdir -p "$(dirname "$LOGFILE")"
echo "==== AdaOS KDE installer started: $(date -Iseconds) ====" >>"$LOGFILE"

# KDE profile -> package
case "$PROFILE" in
  minimal) KDE_TASK="kde-plasma-desktop" ;;
  full)    KDE_TASK="kde-full" ;;
  *)       KDE_TASK="kde-standard" ;;
esac
info "Selected KDE profile: $PROFILE ($KDE_TASK)"

# apt prep
export DEBIAN_FRONTEND=noninteractive
info "Refreshing package list..."
apt-get update -y >>"$LOGFILE" 2>&1

# ask for display manager
info "Choose your Display Manager (login screen):"
echo "  1) sddm   (default, KDE’s DM)"
echo "  2) lightdm"
echo "  3) gdm3"
echo "  4) none   (skip, set up manually later)"
read -rp "Enter choice [1-4]: " DM_CHOICE
case "$DM_CHOICE" in
  2) DM="lightdm" ;;
  3) DM="gdm3" ;;
  4) DM="none" ;;
  *) DM="sddm" ;; # default
esac
info "You selected: $DM"

# install KDE + DM
info "Installing KDE Plasma packages ($KDE_TASK)..."
apt-get install -y --no-install-recommends "$KDE_TASK" >>"$LOGFILE" 2>&1

if [[ "$DM" != "none" ]]; then
  info "Installing Display Manager: $DM"
  apt-get install -y --no-install-recommends "$DM" >>"$LOGFILE" 2>&1
  info "Enabling $DM as default..."
  systemctl enable "$DM"
  systemctl set-default graphical.target
fi

# extras
if [ "$INSTALL_EXTRAS" = true ]; then
  info "Installing AdaOS extras (apps, codecs, printing, flatpak)..."
  apt-get install -y --no-install-recommends \
    dolphin konsole kate ark plasma-disks \
    vlc ffmpeg libavcodec-extra \
    cups printer-driver-all flatpak \
    >>"$LOGFILE" 2>&1 || warn "Some extras failed"
fi

# cleanup
info "Cleaning system..."
apt-get autoremove -y >>"$LOGFILE" 2>&1 || true
apt-get clean >>"$LOGFILE" 2>&1 || true

echo "==== AdaOS KDE installer finished: $(date -Iseconds) ====" >>"$LOGFILE"
info "KDE Plasma ($PROFILE) installation complete on AdaOS."

cat <<EOF

==================== AdaOS KDE Installer ====================
✅ KDE Plasma ($PROFILE) is installed.
✅ Display Manager: $DM
📄 Log: $LOGFILE

Next steps:
  - Reboot your AdaOS system to start KDE.
  - Customize Plasma via System Settings.

EOF

if [ "$AUTO_REBOOT" = true ]; then
  info "Rebooting AdaOS now..."
  /sbin/shutdown -r now
else
  info "Reboot when ready to launch KDE."
fi

export DEBIAN_FRONTEND="$DEBIAN_FRONTEND_DEFAULT"
exit 0

