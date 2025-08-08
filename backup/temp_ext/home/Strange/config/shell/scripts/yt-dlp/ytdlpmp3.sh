ytdlpmp3 () 
{ 
    local DEFAULT_DIR="${HOME}/Music/.yt-music";
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
