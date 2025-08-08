ytfzf() {
    query="$*"
    max=${MAX_RESULTS:-20}

    tmpfile=$(mktemp)
    yt-dlp --get-title --get-id "ytsearch${max}:${query}" \
      | awk 'NR%2{title=$0; next} {printf "%s https://youtu.be/%s\n", title, $0}' > "$tmpfile"

    cat "$tmpfile" | fzf --multi --ansi --prompt="Select video(s): " | awk '{print $NF}'

    rm -f "$tmpfile"
}
##ytfzf() {
##    query="$*"
##    max=${MAX_RESULTS:-10}
##
##    yt-dlp --get-title --get-id "ytsearch${max}:${query}" \
##      | awk 'NR%2{title=$0; next} {printf "%s https://youtu.be/%s\n", title, $0}' \
##      | fzf --multi --ansi --prompt="Select video(s): " \
##      | awk '{print $NF}'
##}
