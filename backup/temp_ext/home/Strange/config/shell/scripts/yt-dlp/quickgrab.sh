quickgrab() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: grab <url1> [url2 ...]"
        return 1
    fi

    for url in "$@"; do
        yt-dlp -N 8 -f "bv*+ba/b" -o "%(title)s.%(ext)s" "$url"
    done
}
