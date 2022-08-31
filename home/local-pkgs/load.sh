# Script_Name: load_window_conf.sh
#! /usr/bin/env bash

save_file="$HOME/.cache/windows-save-file"

nl=$(cat "$save_file" | grep xwininfo |wc -l)
echo Found $nl windows

# Loop over found windows
for i in $(seq 1 $nl); do

    # Find static window information
    ln=$(cat "$save_file" | grep -n "xwininfo" | awk -F'[/:]' -v p="$i" '{if(NR==p) print $1}')
    mywinid[$i]=$(cat "$save_file" | grep "xwininfo" | awk -v p="$i" '{if(NR==p) print $4}') 
    x[$i]=$(cat "$save_file" | grep "Absolute upper-left X" | awk -v p="$i" '{if(NR==p) print $NF}')
    y[$i]=$(cat "$save_file" | grep "Absolute upper-left Y" | awk -v p="$i" '{if(NR==p) print $NF}')
    width[$i]=$(cat "$save_file" | grep "Width" | awk -v p="$i" '{if(NR==p) print $NF}')
    height[$i]=$(cat "$save_file" | grep "Height" | awk -v p="$i" '{if(NR==p) print $NF}')
  
    # Get window id line numbers in save file
    window_idx_s=$(cat "$save_file" | grep -n "xwininfo" | awk -F'[/:]' '{print $1}')
    readarray -t window_idx <<< "$window_idx_s"
  
    # Following informatin is part of window states, which are only 
    # listed if they are active. That's why the above way of finding
    # which window a setting belongs to does not work.
    # Here, for a given state, I find all save file line numbers with the mention.
    # Then I compare between which window ID entries this index would fall into.:w

    # Check if current window is horizontaly maximized
    horz_max[$i]=""
    horzmax_idx=$(cat "$save_file" | grep -n "Maximized Horz" | awk -F'[/:]' '{print $1}')
    for j in $horzmax_idx; do
        if [[ $i -lt $nl ]]; then
            if [[ $j -gt "${window_idx[i-1]}" && $j -lt "${window_idx[i]}" ]]; then
                horz_max[$i]="OK"
            fi
        else
            if [[ $j -gt "${window_idx[i-1]}" ]]; then
                horz_max[$i]="OK"
            fi
        fi
    done

    # Check if current window is verticaly maximized
    vert_max[$i]=""
    vertmax_idx=$(cat "$save_file" | grep -n "Maximized Vert" | awk -F'[/:]' '{print $1}')
    for j in $vertmax_idx; do
        if [[ $i -lt $nl ]]; then
            if [[ $j -gt "${window_idx[i-1]}" && $j -lt "${window_idx[i]}" ]]; then
                vert_max[$i]="OK"
            fi
        else
            if [[ $j -gt "${window_idx[i-1]}" ]]; then
                vert_max[$i]="OK"
            fi
        fi
    done

    # Check if current window is maximized
    maximized[$i]=""
    if [[ (! -z "${horz_max[$i]}") && (! -z "${vert_max[$i]}") ]]; then
        maximized[$i]="OK"
        echo "Window $i: is maximized!"
    fi

    # Check if current window is tiled
    tiled[$i]=""
    tiled_idx=$(cat "$save_file" | grep -n "Tiled" | awk -F'[/:]' '{print $1}')
    for j in $tiled_idx; do
        if [[ $i -lt $nl ]]; then
            if [[ $j -gt "${window_idx[i-1]}" && $j -lt "${window_idx[i]}" ]]; then
                tiled[$i]="OK"
                echo "Window $i is tiled!"
            fi
        else
            if [[ $j -gt "${window_idx[i-1]}" ]]; then
                tiled[$i]="OK"
                echo "Window $i is tiled!"
            fi
        fi
    done

    # Check if current window is fullscreened
    fullscreen[$i]=""
    fullscreen_idx=$(cat "$save_file" | grep -n "Fullscreen" | awk -F'[/:]' '{print $1}')
    for j in $fullscreen_idx; do
        if [[ $i -lt $nl ]]; then
            if [[ $j -gt "${window_idx[i-1]}" && $j -lt "${window_idx[i]}" ]]; then
                tiled[$i]="OK"
                echo "Window $i:${mywinid[$i]} is fullscreen!"
            fi
        else
            if [[ $j -gt "${window_idx[i-1]}" ]]; then
                tiled[$i]="OK"
                echo "Window $i:${mywinid[$i]} is fullscreen!"
            fi
        fi
    done

    # Is window normal?
    if [[ -z "${maximized[$i]}" && -z "${tiled[$i]}" && -z "${fullscreen[$i]}" ]]; then
        echo "Window $i is normal"
    fi

done

echo \>\>Applying windows

for it in $(seq 1 $nl); do
    id="${mywinid[$it]}"
    winopt="${x[$it]}","${y[$it]}","${width[$it]}","${height[$it]}"

    # Unset window state
    if [[ ! -z "${maximized[$it]}" ]]; then
        echo "Maximized window idx: $it"
        wmctrl -i -r $id -b remove,maximized_vert,maximized_horz
    elif [[ ! -z "${fullscreen[$it]}" ]]; then
        echo "Fullscreen window idx: $it"
        wmctrl -i -r $id -b remove,fullscreen
    elif [[ ! -z "${tiled[$it]}" ]]; then
        echo "Tiled window idx: $it"
        maxflag=""
        if [[ ! -z "${horz_max[$it]}" ]]; then
            maxflag=maximized_horz
        elif [[ ! -z "${vert_max[$it]}" ]]; then
            maxflag=maximized_vert
        else
            echo "Tiled window $it does not have any maximized property!"
            exit 1
        fi
        wmctrl -i -r $id -b remove,$maxflag
    else
        echo "Normal window idx: $it"
    fi
    
    # Restore window position
    wmctrl -i -r $id -e 0,$winopt

    # Restore window state (!= normal)
    if [[ ! -z "${maximized[$it]}" ]]; then
        wmctrl -i -r $id -b add,maximized_horz,maximized_vert
    elif [[ ! -z "${fullscreen[$it]}" ]]; then
        wmctrl -i -r $id -b add,fullscreen
    elif [[ ! -z "${tiled[$it]}" ]]; then
        maxflag=""
        if [[ ! -z "${horz_max[$it]}" ]]; then
            maxflag=maximized_horz
        elif [[ ! -z "${vert_max[$it]}" ]]; then
            maxflag=maximized_vert
        else
            echo "Tiled window $it does not have any maximized property!"
            exit 1
        fi
        wmctrl -i -r $id -b add,$maxflag
    fi
done

zenity --info --text="Windows loaded!" || true
