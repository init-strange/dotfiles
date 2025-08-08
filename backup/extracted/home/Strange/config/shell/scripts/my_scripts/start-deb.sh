#!/bin/bash
# vm-debian.sh — Launch Debian VM using QEMU

# ========== CONFIG ========== #
VM_NAME="debian-lab"
DISK_IMG="disk.qcow2"
RAM_MB=4096
CPU_MODEL="host"

# ========== QEMU LAUNCH ========== #
qemu-system-x86_64 \
  -name "$VM_NAME" \
  -m "$RAM_MB" \
  -enable-kvm \
  -cpu "$CPU_MODEL" \
  -drive file="$DISK_IMG",format=qcow2 \
  -net nic \
  -net user \
  -device virtio-vga-gl \
  -display gtk,gl=on,show-menubar=off \
  -usb \
  -device usb-tablet \
  -full-screen
