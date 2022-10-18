# Script_Name: save_window_conf.sh
#! /usr/bin/env bash

file="$HOME/.cache/windows-save-file"

cat /dev/null > $file
wmctrl -p -G -l | awk '($2 != -1)&&($3 != 0)&&($NF != "Desktop")' | awk '{print $1}' | while read mywinid
do
    xwininfo -id "$mywinid" -stats -wm >> $file
done

zenity --info --text="Windows saved!" || true
