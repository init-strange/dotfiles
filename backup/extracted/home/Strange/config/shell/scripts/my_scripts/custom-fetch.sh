
#!/bin/bash
clear
WM=${XDG_CURRENT_DESKTOP:-$DESKTOP_SESSION}
if [ -z "$WM" ]; then
    if pgrep -x sway >/dev/null; then
        WM="sway"
    elif pgrep -x i3 >/dev/null; then
        WM="i3"
    elif pgrep -x dwm >/dev/null; then
        WM="dwm"
    else
        WM="unknown"
    fi
fi

echo "===================== SYSTEM FLEX ====================="
echo "RAM Usage      : $(free -h | awk '/Mem:/ {print $3 " / " $2}')"
echo "CPU Load       : $(uptime | awk -F'load average:' '{print $2}' | sed 's/^ //')"
echo "WM/Desktop     : $WM"
echo "Terminal       : $TERM"
echo "Uptime         : $(uptime -p)"
echo "User Processes : $(ps -u $USER --no-headers | wc -l)"
echo "Idle CPU Usage : $(top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8"%"}')"
echo "Kernel         : $(uname -srmo)"
echo "========================================================"
