#! /bin/bash

WALLPAPER_DIR=${HOME}/Pictures/wallpapers/anime/
RANDOM_PICTURE=$(find "$WALLPAPER_DIR" -type f | shuf -n 1 | xargs basename)
CURRENT_DESKTOP="$(echo "$XDG_CURRENT_DESKTOP" | awk '{for (i=1;i<=NF;i++) { $i=toupper(substr($i,1,1)) tolower(substr($i,2)) }}1')"

case "$CURRENT_DESKTOP" in
  Cinnamon)
    gsettings set org.cinnamon.desktop.background picture-uri "file://$WALLPAPER_DIR/$RANDOM_PICTURE"
    gsettings set org.cinnamon.desktop.background picture-uri-dark "file://$WALLPAPER_DIR/$RANDOM_PICTURE"
    ;;
  Gnome)
    gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DIR/$RANDOM_PICTURE"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_DIR/$RANDOM_PICTURE"
    ;;
  I3)
    if command -v feh > /dev/null; then
      feh --bg-fill "$WALLPAPER_DIR/$RANDOM_PICTURE" && exit
    elif command -v nitrogen > /dev/null; then
      nitrogen --set-auto "$WALLPAPER_DIR/$RANDOM_PICTURE" && exit
    fi
    ;;
  Kde)
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var Desktops = desktops();
for (i=0; i<Desktops.length; i++) {
    d = Desktops[i];
    d.wallpaperPlugin = 'org.kde.image';
    d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
    d.writeConfig('Image', 'file://$WALLPAPER_DIR/$RANDOM_PICTURE');
}"
    ;;
  *)
    notify-send "Error: $(basename "$0")" "Este Script no soporta tu entorno de escritorio."
    exit 1
    ;;
esac

if [[ "$CURRENT_DESKTOP" =~ ^(Gnome|Xfce|Kde|Plasma|Sway|I3)$ ]]; then
  notify-send 'Wallpaper changed:' "$RANDOM_PICTURE"
fi
