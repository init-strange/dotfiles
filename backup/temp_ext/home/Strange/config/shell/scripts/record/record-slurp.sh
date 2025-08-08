#!/usr/bin/env sh

# Record Screen Area Script for Sway/Wayland using wf-recorder + slurp

set -e  # Exit on error

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

##########################
## Area Selection (slurp)
##########################
log_info "Select screen area to record..."
GEOMETRY=$(slurp)
if [ -z "$GEOMETRY" ]; then
    log_error "No area selected. Exiting."
    exit 1
fi
log_info "Area selected: $GEOMETRY"

################
## Start Grab ##
################
trap 'log_warning "Recording stopped. File saved as $OUTPUT"; exit' INT

log_info "Recording started. Press Ctrl+C to stop."
wf-recorder --geometry "$GEOMETRY" -f "$OUTPUT"
