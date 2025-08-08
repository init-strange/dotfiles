IP=""
adbinit(){
    adb kill-server
    adb start-server
    adb tcpip 5555
}
adblink(){
    echo "connecting to $IP"
    adb connect $IP:5555    
    echo "connected to $IP"
}
Strangescr(){
    scrcpy --shortcut-mod=rctrl
}
