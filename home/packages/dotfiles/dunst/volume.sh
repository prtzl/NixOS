command=${1:-""}

function muted()
{
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | command grep -o '\[MUTED\]' || true
}

# Check the passed argument for Volume Up or Volume Down
if [ "$command" == "up" ]; then
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 2%+
    if [[ -n "$(muted)" ]]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    fi
elif [ "$command" == "down" ]; then
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 2%-
    if [[ -n "$(muted)" ]]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    fi
elif [ "$command" == "mute" ]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
else
    echo "Usage: $0 {up|down|mute}"
    exit 1
fi

# Get the current volume and device information
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
device=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | grep 'node.description' | sed -E 's/.*"([^"]+)".*/\1/')

# Check if the system is muted
muted=$(muted)

# Labels for Volume Up, Volume Down, and Mute
label_up="🔊 Volume Up:"
label_down="🔊 Volume Down:"
label_mute="🔇 Mute"
label_unmute="🔊 Un-mute:"

# Define the target width for formatting
len_up=${#label_up}
len_down=${#label_down}
len_mute=${#label_mute}
longest_len=$(( len_up > len_down ? (len_up > len_mute ? len_up : len_mute) : (len_down > len_mute ? len_down : len_mute) ))
padding_after_colon=0
target_width=$((longest_len + padding_after_colon))

# Function to format the aligned output
format_line() {
    local label="$1"
    local vol="$2"
    local padding=$((target_width - ${#label}))
    local spaces
    spaces=$(printf '%*s' "$padding" "")
    printf "%s%s%3d%%\n%s" "$label" "$spaces" "$vol" "$device"
}

# Function to format for mute status
format_mute_line() {
    local label="$1"
    local vol=${2:-""}
    local padding=$((target_width - ${#label}))
    local spaces
    spaces=$(printf '%*s' "$padding" "")
    if [ -z "$vol" ]; then
        printf "%s\n%s" "$label" "$device"
    else
        printf "%s%s%3d%%\n%s" "$label" "$spaces" "$vol" "$device"
    fi
}

# Check the passed argument for Volume Up, Volume Down, or Mute
if [ "$command" == "up" ]; then
    # Volume Up
    dunstify -a "volume" "$(format_line "$label_up" "$volume")" -t 1000 -r 6969 -h int:value:"$volume"
elif [ "$command" == "down" ]; then
    # Volume Down
    dunstify -a "volume" "$(format_line "$label_down" "$volume")" -t 1000 -r 6969 -h int:value:"$volume"
elif [ "$command" == "mute" ]; then
    if [ -z "$muted" ]; then
        # unmuted
        dunstify -a "volume" "$(format_mute_line "$label_unmute" "$volume")" -t 1000 -r 6969 -h int:value:"$volume"
    else
        # muted
        dunstify -a "volume" "$(format_mute_line "$label_mute")" -t 1000 -r 6969 -h int:value:"$volume"
    fi
else
    echo "Usage: $0 {up|down|mute}"
    exit 1
fi
