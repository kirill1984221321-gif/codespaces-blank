#!/bin/bash
echo "=== Post-start: checking for Windows 7 image ==="
if [ -f /workspaces/codespaces-blank/shared_files/win7.qcow2 ]; then
    echo "Windows 7 image found! Starting QEMU with VNC on port 5900..."
    qemu-system-x86_64 -m 4096 -smp 4 -drive file=/workspaces/codespaces-blank/shared_files/win7.qcow2,if=virtio -netdev user,id=net0 -device virtio-net,netdev=net0 -vnc :0 -daemonize
else
    echo "No Windows 7 image found. Skipping auto-start."
fi
