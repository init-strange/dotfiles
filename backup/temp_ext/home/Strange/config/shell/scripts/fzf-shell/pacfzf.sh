pacfzf() {
    local pkg
    pkg=$(pacman -Slq | fzf --multi --reverse --prompt="Search package(s): " \
        --preview 'pacman -Si {} 2>/dev/null' \
        --preview-window=right:60%)

    if [[ -n "$pkg" ]]; then
        local pkg_list
        pkg_list=$(echo "$pkg" | tr '\n' ' ')
        local count
        count=$(echo "$pkg_list" | wc -w)

        # Detect if we're inside a subshell (command substitution)
        if [[ -t 1 ]]; then
            # Normal interactive mode → pretty {x,y,z} format
            echo "{"$(echo "$pkg_list" | paste -sd "," -)"}"
        else
            # Inside $(...) → safe space-separated list
            echo "$pkg_list"
        fi
    fi
}
pacfzf_installed() {
    local pkgs
    pkgs=$(pacman -Qq | fzf --multi --prompt="Search installed package(s): ")
    [[ -z "$pkgs" ]] && return 1

    local pkg_list
    pkg_list=$(echo "$pkgs" | tr '\n' ' ')

    if [[ -t 1 ]]; then
        # Interactive (printed to terminal)
        echo "{"$(echo "$pkg_list" | paste -sd "," -)"}"
    else
        # Inside $(...) → safe space-separated output
        echo "$pkg_list"
    fi
}
