:q () 
{ 
    exit
}
:q! () 
{ 
    exit
}
:w () 
{ 
    echo "[bash] E212: Can't open file for writing"
}
:wq () 
{ 
    echo "[bash] E492: Not an editor"
}
__fzf_dir_insert () 
{ 
    local selected;
    selected=$(find . -type d 2> /dev/null | fzf --multi);
    if [[ -n "$selected" ]]; then
        local insert="";
        while IFS= read -r dir; do
            insert+="\"$dir\" ";
        done <<< "$selected";
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${insert}${READLINE_LINE:$READLINE_POINT}";
        READLINE_POINT=$(( READLINE_POINT + ${#insert} ));
    fi
}
__fzf_file_insert () 
{ 
    local selected;
    selected=$(fzf --multi);
    if [[ -n "$selected" ]]; then
        local insert="";
        while IFS= read -r line; do
            insert+="\"$line\" ";
        done <<< "$selected";
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${insert}${READLINE_LINE:$READLINE_POINT}";
        READLINE_POINT=$(( READLINE_POINT + ${#insert} ));
    fi
}
__fzf_history_insert () 
{ 
    local selected;
    selected=$(history | fzf --multi --reverse | sed 's/ *[0-9]* *//');
    if [[ -n "$selected" ]]; then
        local insert="";
        while IFS= read -r cmd; do
            insert+="$cmd; ";
        done <<< "$selected";
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${insert}${READLINE_LINE:$READLINE_POINT}";
        READLINE_POINT=$(( READLINE_POINT + ${#insert} ));
    fi
}
__python_argcomplete_run () 
{ 
    if [[ -z "${ARGCOMPLETE_USE_TEMPFILES-}" ]]; then
        __python_argcomplete_run_inner "$@";
        return;
    fi;
    local tmpfile="$(mktemp)";
    _ARGCOMPLETE_STDOUT_FILENAME="$tmpfile" __python_argcomplete_run_inner "$@";
    local code=$?;
    cat "$tmpfile";
    rm "$tmpfile";
    return $code
}
__python_argcomplete_run_inner () 
{ 
    if [[ -z "${_ARC_DEBUG-}" ]]; then
        "$@" 8>&1 9>&2 > /dev/null 2>&1 < /dev/null;
    else
        "$@" 8>&1 9>&2 1>&9 2>&1 < /dev/null;
    fi
}
__strange_check_interrupt () 
{ 
    local last=$?;
    if [[ $last -eq 130 ]]; then
        on_interrupt;
    fi;
    return $last
}
_python_argcomplete () 
{ 
    local IFS='';
    local script="";
    if [[ -n "${ZSH_VERSION-}" ]]; then
        local completions;
        completions=($(IFS="$IFS" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" _ARGCOMPLETE=1 _ARGCOMPLETE_SHELL="zsh" _ARGCOMPLETE_SUPPRESS_SPACE=1 __python_argcomplete_run ${script:-${words[1]}}));
        local nosort=();
        local nospace=();
        if is-at-least 5.8; then
            nosort=(-o nosort);
        fi;
        if [[ "${completions-}" =~ ([^\\]): && "${match[1]}" =~ [=/:] ]]; then
            nospace=(-S '');
        fi;
        _describe "${words[1]}" completions "${nosort[@]}" "${nospace[@]}";
    else
        local SUPPRESS_SPACE=0;
        if compopt +o nospace 2> /dev/null; then
            SUPPRESS_SPACE=1;
        fi;
        COMPREPLY=($(IFS="$IFS" COMP_LINE="$COMP_LINE" COMP_POINT="$COMP_POINT" COMP_TYPE="$COMP_TYPE" _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" _ARGCOMPLETE=1 _ARGCOMPLETE_SHELL="bash" _ARGCOMPLETE_SUPPRESS_SPACE=$SUPPRESS_SPACE __python_argcomplete_run ${script:-$1}));
        if [[ $? != 0 ]]; then
            unset COMPREPLY;
        else
            if [[ $SUPPRESS_SPACE == 1 ]] && [[ "${COMPREPLY-}" =~ [=/:]$ ]]; then
                compopt -o nospace;
            fi;
        fi;
    fi
}
adbinit () 
{ 
    adb kill-server;
    adb start-server;
    adb tcpip 5555;
    echo "dissconnect wire and link"
}
adblink () 
{ 
    IP="192.0.0.4";
    echo "connecting to $IP";
    adb connect $IP:5555;
    echo "connected to $IP"
}
android () 
{ 
    MAX_RES="1024";
    BITRATE="8M";
    FPS="60";
    echo "[+] Launching scrcpy (no control, passive mode)...";
    scrcpy --shortcut-mod=rctrl --no-audio --stay-awake --max-size "$MAX_RES" --video-bit-rate "$BITRATE" --max-fps "$FPS" --window-title "STRANGE PHONE"
}
btconnect () 
{ 
    local DEVICE_MAC="08:12:87:3C:34:00";
    if ! systemctl is-active --quiet bluetooth; then
        echo "Error: Bluetooth service is not running.";
        return 1;
    fi;
    if [[ ! $DEVICE_MAC =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
        echo "Error: Invalid Bluetooth MAC address: $DEVICE_MAC";
        return 1;
    fi;
    if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
        echo "Device $DEVICE_MAC is already connected.";
        return 0;
    fi;
    echo -e "power on\nconnect $DEVICE_MAC\ntrust $DEVICE_MAC\nquit" | bluetoothctl
}
chmod_shell_scripts () 
{ 
    dir="$HOME/.config/shell/scripts/";
    if [[ -d "$dir" ]]; then
        find "$dir" -type f -name "*.sh" -exec chmod +x {} +;
        echo "Made all .sh scripts in $dir executable.";
    else
        echo "Directory not found: $dir";
    fi
}
chmod_sway_scripts () 
{ 
    dir="$HOME/.config/sway/scripts";
    if [[ -d "$dir" ]]; then
        find "$dir" -type f -name "*.sh" -exec chmod +x {} +;
        echo "Made all .sh scripts in $dir executable.";
    else
        echo "Directory not found: $dir";
    fi
}
color () 
{ 
    if [[ ! -x "$COLOR_TOOL_PATH" ]]; then
        echo "color-tool not found at $COLOR_TOOL_PATH" 1>&2;
        return 1;
    fi;
    "$COLOR_TOOL_PATH" "$@"
}
command_not_found_handle () 
{ 
    echo "STRANGE does not recognize that peasant command: '$1'" 1>&2;
    return 127
}
connectwifi () 
{ 
    ssid="STRANGE";
    password="12345678";
    echo "reconnecting to $ssid...";
    echo "enter pass:";
    nmcli device wifi connect $ssid password $password
}
fetch () 
{ 
    bash $HOME/.config/shell/scripts/my_scripts/custom-fetch.sh
}
full-backup () 
{ 
    bash $HOME/.config/shell/scripts/my_scripts/backup/backup.sh
}
gawklibpath_append () 
{ 
    [ -z "$AWKLIBPATH" ] && AWKLIBPATH=`gawk 'BEGIN {print ENVIRON["AWKLIBPATH"]}'`;
    export AWKLIBPATH="$AWKLIBPATH:$*"
}
gawklibpath_default () 
{ 
    unset AWKLIBPATH;
    export AWKLIBPATH=`gawk 'BEGIN {print ENVIRON["AWKLIBPATH"]}'`
}
gawklibpath_prepend () 
{ 
    [ -z "$AWKLIBPATH" ] && AWKLIBPATH=`gawk 'BEGIN {print ENVIRON["AWKLIBPATH"]}'`;
    export AWKLIBPATH="$*:$AWKLIBPATH"
}
gawkpath_append () 
{ 
    [ -z "$AWKPATH" ] && AWKPATH=`gawk 'BEGIN {print ENVIRON["AWKPATH"]}'`;
    export AWKPATH="$AWKPATH:$*"
}
gawkpath_default () 
{ 
    unset AWKPATH;
    export AWKPATH=`gawk 'BEGIN {print ENVIRON["AWKPATH"]}'`
}
gawkpath_prepend () 
{ 
    [ -z "$AWKPATH" ] && AWKPATH=`gawk 'BEGIN {print ENVIRON["AWKPATH"]}'`;
    export AWKPATH="$*:$AWKPATH"
}
invoke () 
{ 
    if ! "$@"; then
        local code=$?;
        echo -e "\n[!] Command failed: $*";
        echo "[!] STRANGE is disappointed by your incompetence. Elevate yourself.";
        echo "[*] Exit code: $code";
        return $code;
    fi
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
lock-suspend () 
{ 
    bash ~/.config/sway/scripts/lock-suspend.sh
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
new-gtk-theme () 
{ 
    bash $HOME/.config/shell/scripts/my_scripts/new-theme.sh "$@"
}
nuke () 
{ 
    bash $HOME/.config/shell/scripts/my_scripts/nuke.sh
}
on_error () 
{ 
    echo -e "\n[!] Execution failed... STRANGE expected perfection."
}
on_interrupt () 
{ 
    echo -e "\n[!] Rage quit detected... STRANGE is furious."
}
parse_git_branch () 
{ 
    git rev-parse --is-inside-work-tree &> /dev/null || return;
    echo " [$(git rev-parse --abbrev-ref HEAD 2> /dev/null)]"
}
please () 
{ 
    if [[ "$EUID" -eq 0 ]]; then
        invoke "$@";
    else
        sudo env STRANGE_WRAP=1 bash -c '
      source /home/Strange/.config/sway/scripts/my_scripts/narcissist.sh
      invoke "$@"
    ' bash "$@";
    fi
}
popkitty () 
{ 
    kitty --detach sh -c "cd \"$PWD\"; exec bash"
}
quicklaunch_config () 
{ 
    path="$HOME/.config";
    cd "$path";
    if [ "$#" -gt 0 ]; then
        "$@";
    fi
}
quicklaunch_documents () 
{ 
    path="$HOME/Downloads/Firefox_Downloads/documents/";
    cd "$path";
    if [ "$#" -gt 0 ]; then
        "$@";
    fi
}
quicklaunch_notes () 
{ 
    path="$HOME/purgatory/notes/my_notes";
    cd "$path";
    if [ "$#" -gt 0 ]; then
        "$@";
    fi
}
quicklaunch_projects () 
{ 
    path="$HOME/purgatory";
    cd "$path";
    if [ "$#" -gt 0 ]; then
        "$@";
    fi
}
remapcaps () 
{ 
    bash $HOME/.config/shell/scripts/my_scripts/keymap.sh
}
resetnetworking () 
{ 
    nmcli networking off && nmcli networking on
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
todo () 
{ 
    local file="$HOME/purgatory/notes/my_notes/todo.md";
    [[ -f "$file" ]] || touch "$file";
    case "$1" in 
        -e | --edit)
            $EDITOR "$file"
        ;;
        -a | --add)
            shift;
            local text="$*";
            if [[ -z "$text" ]]; then
                echo "Usage: todo -a <task text>";
                return 1;
            fi;
            local count;
            count=$(grep -c '^[0-9]\+\. \[ \]' "$file" 2> /dev/null) || count=0;
            local num=$((count + 1));
            echo "$num. [ ] $text" >> "$file";
            echo "Added: $num. [ ] $text"
        ;;
        "")
            less +Gg "$file"
        ;;
        *)
            echo "Usage: todo [-e|--edit] [-a|--add <text>]"
        ;;
    esac
}
vm-deb () 
{ 
    bash $HOME/.config/shell/scripts/my_scripts/start-deb.sh
}
ytdlpmp3 () 
{ 
    local DEFAULT_DIR="${HOME}/Music/yt-music";
    local ARCHIVE_FILE="${DEFAULT_DIR}/yt-dlp-archive.txt";
    if [ -z "$1" ]; then
        echo "Usage: ytdlpmp3 <playlist_url>";
        return 1;
    fi;
    local PLAYLIST_URL="$1";
    local TARGET_DIR="";
    echo "Choose target location:";
    echo "  [Enter] = default ($DEFAULT_DIR)";
    echo "  n       = current directory under custom folder name";
    read -rp "Choice: " LOCATION_CHOICE;
    if [[ "$LOCATION_CHOICE" == "n" ]]; then
        read -rp "Enter folder name to create in current directory: " CUSTOM_NAME;
        if [[ -z "$CUSTOM_NAME" ]]; then
            echo "Folder name cannot be empty. Aborting.";
            return 1;
        fi;
        TARGET_DIR="$(pwd)/$CUSTOM_NAME";
        ARCHIVE_FILE="${TARGET_DIR}/yt-dlp-archive.txt";
        LOG_FILE="${TARGET_DIR}/ytdlp-$(date +'%Y-%m-%d_%H-%M-%S').log";
    else
        TARGET_DIR="$DEFAULT_DIR";
        ARCHIVE_FILE="${DEFAULT_DIR}/yt-dlp-archive.txt";
        LOG_FILE="${DEFAULT_DIR}/ytdlp-$(date +'%Y-%m-%d_%H-%M-%S').log";
    fi;
    mkdir -p "$TARGET_DIR";
    echo "Downloading to: $TARGET_DIR";
    yt-dlp -f bestaudio --extract-audio --audio-format mp3 --embed-thumbnail --add-metadata --download-archive "$ARCHIVE_FILE" -o "${TARGET_DIR}/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" "$PLAYLIST_URL" | tee "$LOG_FILE"
}
