#!/usr/bin/env sh
MUSIC_DIR="${HOME}/Music"
IGNORE_PATHS=(
    ! -path "$MUSIC_DIR/.yt-music/*"
    ! -path "$MUSIC_DIR/.lyrics/*"
    ! -path "*/.yt-music/*"
    ! -path "*/.lyrics/*"
)

music () 
{ 
    if mpc status | grep -q '\[playing\]'; then
        echo "[x] Stopping music...";
        mpc stop && pkill mpd;
        return;
    fi;
    echo "[>] Starting music (random mode)...";
    pgrep -x mpd > /dev/null || mpd;
    sleep 0.5;
    echo "[~] Updating music library...";
    mpc update > /dev/null;
    sleep 0.5;
    if ! mpc > /dev/null 2>&1; then
        echo "[!] Could not connect to MPD.";
        echo "try running daemon first";
        return 1;
    fi;
    mpc clear;
    mpc listall | grep -v "^\.yt-music/" | mpc add;
    mpc shuffle ;
    mpc random off;
    mpc repeat on;
    mpc play
}

m () 
{ 
    if ! pgrep -x mpd > /dev/null; then
        echo "[!] MPD is not running. Starting music...";
        music;
        return;
    fi;
    if ! mpc > /dev/null 2>&1; then
        echo "[!] Cannot connect to MPD — is it configured right?";
        return 1;
    fi;
    mpc toggle
}

seek () 
{ 
    mpc status;
    echo;
    if [[ -z "$1" ]]; then
        echo "Usage: seek [+|-|%]seconds";
        echo "Example: seek +10   # seek forward 10 seconds";
        echo "         seek -5    # seek back 5 seconds";
        echo "         seek 5    # seek to 5 second mark";
        return;
    fi;
    echo;
    mpc seek "$1";
    mpc status
}

playlist () 
{ 
    if ! mpc > /dev/null 2>&1; then
        echo "[!] Could not connect to MPD.";
        return;
    fi;
    local current playlist numbered menu selected track_index current_index;
    current=$(mpc current);
    playlist=$(mpc playlist);
    current_index=$(printf "%s\n" "$playlist" | grep -nF "$current" | cut -d: -f1);
    numbered=$(printf "%s\n" "$playlist" | nl -w1 -s') ');
    menu=$(printf "[ %s ] → %s\n%s" "$current_index" "$current" "$numbered");
    selected=$(printf "%s\n" "$menu" | fzf --reverse --prompt="[>>] Jump to song: " --height=90%);
    [[ -z "$selected" ]] && return;
    if [[ "$selected" =~ ^\[.*\] ]]; then
        echo " Staying on current track: $current";
        return;
    fi;
    track_index=$(cut -d')' -f1 <<< "$selected");
    echo " Playing track #$track_index";
    mpc play "$track_index"
}
playdir () 
{ 
    if ! mpc > /dev/null 2>&1; then
        echo "[!] Could not connect to MPD.";
        return 1;
    fi;
mapfile -t dirs < <(
    find "$MUSIC_DIR" -mindepth 1 \
        \( -name ".yt-music" -o -name ".lyrics" \) -prune -o \
        -type d -printf '%P\n' | sort -R
);
    [[ ${#dirs[@]} -eq 0 ]] && { 
        echo "[!] No music directories found.";
        return 1
    };
    IFS='
' selected=($(printf "%s\n" "${dirs[@]}" | fzf --multi --reverse --prompt="[>>] Choose folders: " --height=90%));
    unset IFS;
    [[ ${#selected[@]} -eq 0 ]] && { 
        echo "No selection made.";
        return 0
    };
    local exts=(-iname '*.mp3' -o -iname '*.flac' -o -iname '*.m4a' -o -iname '*.ogg' -o -iname '*.wav' -o -iname '*.aac');
    tracks=();
    for d in "${selected[@]}";
    do
        while IFS= read -r -d '' fpath; do
            tracks+=("${fpath#$MUSIC_DIR/}");
        done < <(find "$MUSIC_DIR/$d" -type f "${IGNORE_PATHS[@]}" \( "${exts[@]}" \) -print0)
    done;
    [[ ${#tracks[@]} -eq 0 ]] && { 
        echo "[!] No audio files found.";
        return 1
    };
    mpc clear;
    printf "%s\n" "${tracks[@]}" | mpc add;
    mpc random off;
    mpc repeat on;
    mpc play;
    echo "▶ Now playing from (selected):";
for d in "${selected[@]}"; do
    if [ -d "$MUSIC_DIR/$d" ]; then
        if command -v tree > /dev/null 2>&1; then
            tree -d -C -L 2 "$MUSIC_DIR/$d"
        else
            echo "$d/"
            find "$MUSIC_DIR/$d" -mindepth 1 -maxdepth 2 -printf '  %P\n'
        fi
    fi
done
    echo "▶ Now playing from:";
    printf "    %s\n" "${selected[@]}";
    mpc status | head -1
}

play_next () {

    # Ensure MPD connection
    if ! mpc > /dev/null 2>&1; then
        echo "[!] Could not connect to MPD."
        return 1
    fi

    # Select a file with fzf
    local selected
    selected=$(find "$MUSIC_DIR" \
            "${IGNORE_PATHS[@]}" \
            -type f \
            \( -iname '*.mp3' -o -iname '*.flac' -o -iname '*.m4a' \
               -o -iname '*.ogg' -o -iname '*.wav' -o -iname '*.aac' \) \
        | shuf \
        | sed "s|$MUSIC_DIR/||" \
        | fzf --reverse --multi --prompt="[>>] Choose song to queue next: " --height=90%)

    [[ -z "$selected" ]] && {
        echo "No selection made."
        return 0
    }

    # Insert after the currently playing track
    mpc insert "$selected"
    echo "[+] Queued next: $selected"

    # Figure out current position
    local pos
    pos=$(mpc playlist | grep -nF "$(mpc current)" | cut -d: -f1)

    # Show upcoming track
    echo "[.] Now playing: $(mpc current)"
    echo "[>] Up next: $(mpc playlist | sed -n "$((pos + 1))p")"
}

music_menu() {

    if ! mpc > /dev/null 2>&1; then
        echo "[!] Could not connect to MPD.";
        return;
    fi;
    while true; do
        choice=$(printf "%s\n" \
            "Seek +5%" \
            "Play/Pause" \
            "Next Song" \
            "Previous Song" \
            "Shuffle" \
            "Playlist" \
            "Playdir" \
            "Queue Next" \
            "Exit" \
            | fzf --reverse --prompt="[Music Menu]" --height=90%)

        case "$choice" in
            "Seek +5%") mpc seek +5% ;;
            "Play/Pause") mpc toggle ;;
            "Next Song") mpc next ;;
            "Previous Song") mpc prev ;;
            "Shuffle") mpc shuffle ;;
            "Playlist") playlist ;;
            "Playdir") playdir ;;
            "Queue Next") play_next ;;
            "Exit"|"") break ;;
        esac
    done
}
