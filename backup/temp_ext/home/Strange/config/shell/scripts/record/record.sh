#!/usr/bin/env sh

record_script_path="/home/Strange/.config/shell/scripts/record"
BLUE="\e[34m"; RESET="\e[0m"; RED="\e[31m"; YELLOW="\e[33m"; GREEN="\e[32m"
log_info()    { echo -e "${BLUE}[INFO]${RESET} $1"; }
log_warning() { echo -e "${YELLOW}[WARN]${RESET} $1"; }
log_error()   { echo -e "${RED}[ERROR]${RESET} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${RESET} $1"; }

# Output file
timestamp=$(date +'%Y%m%d_%H%M%S')
output_file="$HOME/Videos/recording/recording_$timestamp.mkv"

#########################
## Audio Toggle (default: no)
#########################
read -r -p "$(echo -e "${BLUE}[?]${RESET} Record audio? (y/N): ")" AUDIO_CHOICE
case "$AUDIO_CHOICE" in
    y|Y|yes|Yes|YES)
        AUDIO_ARG="--audio"
        log_info "Audio recording ENABLED."
        ;;
    *)
        AUDIO_ARG=""
        log_info "Audio recording DISABLED."
        ;;
esac
echo

#########################
## Region Toggle (default: fullscreen)
#########################
read -r -p "$(echo -e "${BLUE}[?]${RESET} Record full screen or slurp area? (Enter 's' for slurp, default is full): ")" REGION_CHOICE
if [ "$REGION_CHOICE" = "s" ] || [ "$REGION_CHOICE" = "S" ]; then
    if ! command -v slurp >/dev/null 2>&1; then
        log_error "slurp not found for region selection."
        exit 1
    fi
    region=$(slurp)
    if [ -z "$region" ]; then
        log_error "No region selected. Aborting."
        exit 1
    fi
    log_info "Recording region: $region"
    wf-recorder $AUDIO_ARG -g "$region" -f "$output_file"
else
    log_info "Recording full screen..."
    wf-recorder $AUDIO_ARG -f "$output_file"
fi

log_success "Recording saved to: $output_file"
