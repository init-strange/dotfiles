
btconnect () 
{ 
    local DEVICE_MAC="08:12:87:3C:34:00";
    if ! systemctl is-active --quiet bluetooth; then
        echo "Error: Bluetooth service is not running.";
        return 1;
    fi;
    if [[ ! $DEVICE_MAC =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
        echo "Error: Invalid Bluetooth MAC address: $DEVICE_MAC";
        return 1;
    fi;
    if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
        echo "Device $DEVICE_MAC is already connected.";
        return 0;
    fi;
    echo -e "power on\nconnect $DEVICE_MAC\ntrust $DEVICE_MAC\nquit" | bluetoothctl
}
