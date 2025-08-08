
#!/bin/bash
set -euo pipefail

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GRAY='\033[0;90m'
NC='\033[0m'

clear

# Memory before nuking
mem_before=$(free -h | awk '/^Mem:/ {print $3}')
mem_before_mib=$(free -m | awk '/^Mem:/ {print $3}')

# ASCII Bomb
echo -e "${RED}"
cat << "EOF"
                 @@@@@@@@@@@@@@@@@@
              @@@@@@@@@@@@@@@@@@@@@@@
           @@@@@@@@@@@@@@@@@@@@@@@@@@@
          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
         @@@@@@@@@@@@@@@/      \@@@/   @
        @@@@@@@@@@@@@@@\      @@  @___@
        @@@@@@@@@@@@@ @@@@@@@@@@  | \@@@@@
        @@@@@@@@@@@@@ @@@@@@@@@\__@_/@@@@@
         @@@@@@@@@@@@@@@/,/,/./'/_|.\'\,\
           @@@@@@@@@@@@@|  | | | | | | | |
                         \_|_|_|_|_|_|_|_|
EOF
echo -e "${NC}"

# Banner
echo -e "${GRAY}============================================================================${NC}"
echo -e "${RED}||        NUKING BACKGROUND DAEMONS — THE PURGE HAS BEGUN, STRANGE         ||${NC}"
echo -e "${GRAY}============================================================================${NC}"

# Kill list
processes=(clangd node code electron tsserver pylsp rust-analyzer gopls)

killed_any=false
for proc in "${processes[@]}"; do
  if pkill -x "$proc" > /dev/null 2>&1; then
    echo -e "${GREEN} - ${proc} terminated${NC}"
    killed_any=true
  fi
done

# Cleanse result
printf "${CYAN}/============================ CLEANSE COMPLETE =============================\\\\${NC}\n"
if [[ "$killed_any" = false ]]; then
  printf "${GRAY}>>                         No dev daemons were running.                      <<${NC}\n"
else
  echo -e "${GREEN}>>>>>>>>>>>>>>  System cleaned. Firefox remains king.  <<<<<<<<<<<<<${NC}"
fi
printf "${CYAN}\\\\===========================================================================/${NC}\n"

# RAM result
mem_after=$(free -h | awk '/^Mem:/ {print $3}')
mem_after_mib=$(free -m | awk '/^Mem:/ {print $3}')
delta_mib=$((mem_before_mib - mem_after_mib))

echo -e "${YELLOW} RAM Before: ${mem_before}    |    RAM After: ${mem_after} ${NC}"
echo -e "${GREEN} >>> Reclaimed: ${delta_mib} MiB${NC}"
