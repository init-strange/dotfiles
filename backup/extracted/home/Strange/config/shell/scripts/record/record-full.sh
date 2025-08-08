#!/usr/bin/env sh

# Record Full Screen Script for Sway/Wayland using wf-recorder

set -e  # Exit if any error occurs

############
## COLORS ##
############
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

##################
## LOG FUNCTION ##
##################
log_info()    { echo -e "${BLUE}[INFO]${RESET} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${RESET} $1"; }
log_error()   { echo -e "${RED}[ERROR]${RESET} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${RESET} $1"; }

#####################
## Output Location ##
#####################
OUTPUT_DIR="$HOME/Videos"
mkdir -p "$OUTPUT_DIR"

OUTPUT="$OUTPUT_DIR/recording_$(date +'%Y-%m-%d_%H-%M-%S').mkv"
log_info "Saving to: $OUTPUT"

################
## Start Grab ##
################
trap 'log_warning "Recording stopped. File saved as $OUTPUT"; exit' INT

log_info "Recording full screen. Press Ctrl+C to stop."
wf-recorder -f "$OUTPUT"
