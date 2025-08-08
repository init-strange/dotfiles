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
    mpc shuffle && mpc random off;
    mpc repeat on;
    mpc play
}
jump_list () 
{ 
    local MUSIC_DIR="${HOME}/Music";
    if ! mpc > /dev/null 2>&1; then
        echo "[!] Could not connect to MPD.";
        return 1;
    fi;
    mapfile -t dirs < <(find "$MUSIC_DIR" -mindepth 1 -type d ! -path "$MUSIC_DIR/.yt-music*" -printf '%P\n' | sort);
    [[ ${#dirs[@]} -eq 0 ]] && { 
        echo "[!] No music directories found.";
        return 1
    };
    IFS='
' selected=($(printf "%s\n" "${dirs[@]}" | fzf --multi --reverse --prompt="[>>] Choose folders: "));
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
        done < <(find "$MUSIC_DIR/$d" -type f ! -path "$MUSIC_DIR/.yt-music/*" \( "${exts[@]}" \) -print0);
    done;
    [[ ${#tracks[@]} -eq 0 ]] && { 
        echo "[!] No audio files found.";
        return 1
    };
    mpc clear;
    printf "%s\n" "${tracks[@]}" | mpc add;
    mpc shuffle;
    mpc random off;
    mpc repeat on;
    mpc play;
    echo "▶ Now playing from (selected):";
    for d in "${selected[@]}";
    do
        if command -v tree > /dev/null 2>&1; then
            tree -d -C -L 2 "$MUSIC_DIR/$d";
        else
            echo "$d/";
            find "$MUSIC_DIR/$d" -mindepth 1 -maxdepth 2 -printf '  %P\n';
        fi;
    done;
    echo "▶ Now playing from:";
    printf "    %s\n" "${selected[@]}";
    mpc status | head -1
}
jump_song () 
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
    selected=$(printf "%s\n" "$menu" | fzf --reverse --prompt="[>>] Jump to song: ");
    [[ -z "$selected" ]] && return;
    if [[ "$selected" =~ ^\[.*\] ]]; then
        echo " Staying on current track: $current";
        return;
    fi;
    track_index=$(cut -d')' -f1 <<< "$selected");
    echo " Playing track #$track_index";
    mpc play "$track_index"
}
