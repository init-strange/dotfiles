#!/usr/bin/env sh
set -e

# Color log helpers
RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; BLUE="\e[34m"; RESET="\e[0m"
log_info()    { echo -e "${BLUE}[INFO]${RESET} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${RESET} $1"; }
log_error()   { echo -e "${RED}[ERROR]${RESET} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${RESET} $1"; }

# Output
OUTPUT_DIR="$HOME/Videos/recorded-audio/"
mkdir -p "$OUTPUT_DIR"
OUTPUT="$OUTPUT_DIR/audio_$(date +'%Y-%m-%d_%H-%M-%S').mkv"
log_info "Saving audio to: $OUTPUT"

# Sources
MIC_SOURCE="alsa_input.pci-0000_04_00.6.analog-stereo"
SYS_SOURCE="alsa_output.pci-0000_04_00.6.analog-stereo.monitor"

CHOICE="$1"

if [ -z "$CHOICE" ]; then
  log_info "Select audio source:"
  echo "1) Microphone"
  echo "2) System Audio"
  echo "3) Both"
  read -r -p "[Default: 2] > " CHOICE
fi

case "$CHOICE" in
  1|--mic)
    log_info "Recording Microphone only..."
    ffmpeg -f pulse -i "$MIC_SOURCE" -acodec pcm_s16le "$OUTPUT"
    ;;
  3|--both)
    log_info "Recording Both Microphone and System Audio..."
    ffmpeg -f pulse -i "$MIC_SOURCE" -f pulse -i "$SYS_SOURCE" \
      -filter_complex "[0:a][1:a]amerge=inputs=2[aout]" \
      -map "[aout]" -ac 2 -c:a pcm_s16le "$OUTPUT"
    ;;
  2|--system|*)
    log_info "Recording System Audio..."
    ffmpeg -f pulse -i "$SYS_SOURCE" -acodec pcm_s16le "$OUTPUT"
    ;;
esac

log_success "Recording saved to $OUTPUT"
